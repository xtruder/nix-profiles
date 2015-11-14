{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.vswitch;

  remoteOptions = { name, ... }: {
    options = {
      name = mkOption {
        description = "Name of the remote";
        type = types.str;
        default = name;
      };

      remoteIp = mkOption {
        description = "Node remote ip.";
        type = types.str;
      };

      psk = mkOption {
        description = "IPSec pre shared key for a connection.";
        type = types.str;
      };

      port = mkOption {
        description = "OpenVswitch port id.";
        type = types.int;
      };
    };
  };

  interfaceOptions = { name, config, ... }: {
    options = {
      bridgeTo = mkOption {
        description = "Bridge to interface.";
        type = types.str;
        default = name;
      };

      interface = mkOption {
        description = "Name of the internal tun interface.";
        type = types.str;
        default = "tun-${config.bridgeTo}";
      };

      port = mkOption {
        description = "OpenVswitch port if of interface.";
        type = types.int;
      };

      subnet = mkOption {
        description = "Interface subnet.";
        type = types.str;
      };

      networks = mkOption {
        description = "List of networks that interface is connected to.";
        type = types.listOf types.optionSet;
        options = {
          remote = mkOption {
            description = "Name of the remote.";
            type = types.str;
          };
          subnet = mkOption {
            description = "Subnet ip.";
            type = types.str;
          };
        };
        default = [];
        example = [
          { remote = "node0"; subnet = "10.244.2.1/24"; }
        ];
      };
    };
  };
in {
  options.profiles.vswitch = {
    enable = mkEnableOption "Whether to enable vswitch profile.";

    interfaces = mkOption {
      description = "Attribute set of local interfaces.";
      type = types.attrsOf types.optionSet;
      options = [ interfaceOptions ];
    };

    remotes = mkOption {
      description = "Attribute set of vswitch networks.";
      type = types.attrsOf types.optionSet;
      options = [ remoteOptions ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bridge-utils pkgs.tcpdump ];

    virtualisation.vswitch.ipsec = true;
    virtualisation.vswitch.enable = true;
    networking.firewall.allowedUDPPorts = [ 500 4500 ];
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p 47 -j ACCEPT # GRE
      iptables -A nixos-fw -p 50 -j ACCEPT # ESP
    '';
    systemd.services.ovsconfig = {
      wantedBy = [ "multi-user.target" ];
      after = [ "vswitchd.service" "ovs-monitor-ipsec.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        export PATH=/var/run/current-system/sw/bin:$PATH

        # add ovs bridge
        ovs-vsctl --may-exist add-br obr0 -- set Bridge obr0 fail-mode=secure
        ovs-vsctl set bridge obr0 protocols=OpenFlow13
        ovs-vsctl --may-exist add-port obr0 gre0 -- set Interface gre0 type=gre options:remote_ip="flow" options:key="flow" ofport_request=8

        # add oflow rules, because we do not want to use stp
        ovs-ofctl -O OpenFlow13 del-flows obr0

        ${concatStrings (mapAttrsToList (n: inf: let
        in ''
          ## Config for interface ${inf.interface} ##

          # add tun device
          ovs-vsctl --may-exist add-port obr0 ${inf.interface} -- set Interface ${inf.interface} type=internal ofport_request=${toString inf.port}

          brctl addif ${inf.bridgeTo} ${inf.interface} || true
          ip link set ${inf.interface} up

          # Handle input flows ${inf.subnet}
          ovs-ofctl -O OpenFlow13 add-flow obr0 "table=0,ip,nw_dst=${inf.subnet},in_port=8,actions=output:${toString inf.port}"
          ovs-ofctl -O OpenFlow13 add-flow obr0 "table=0,arp,nw_dst=${inf.subnet},in_port=8,actions=output:${toString inf.port}"

          # now loop through networks, interface is connected to and create flows
          ${concatMapStrings (net: let
            remote = cfg.remotes.${net.remote};
          in ''
            # Handle output flows
            ovs-ofctl -O OpenFlow13 add-flow obr0 "table=0,in_port=${toString inf.port},ip,nw_dst=${net.subnet},actions=output:8"
            ovs-ofctl -O OpenFlow13 add-flow obr0 "table=0,in_port=${toString inf.port},arp,nw_dst=${net.subnet},actions=output:8"
          '') inf.networks}

        '') cfg.interfaces)}
      '';
    };

  };
}
