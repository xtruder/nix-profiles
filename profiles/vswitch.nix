{ config, lib, pkgs, ... }:

with lib;
      # IPSEC encrpyted links to all hosts
        #${concatStrings (imap (i: n: let
          #net = n.config.networking;
        #in if net.publicIPv4 != config.networking.publicIPv4 then ''
        #ovs-vsctl --may-exist add-port obr0 gre0-${net.hostName} -- set Interface gre0-${net.hostName} type=ipsec_gre options:remote_ip="${net.publicIPv4}" options:psk=test ofport_request=${toString i}
        #'' else "") cfg.nodes)}


let
  cfg = config.profiles.vswitch;
in {
  options.profiles.vswitch = {
    enable = mkEnableOption "Whether to enable vswitch profile.";

    interface = mkOption {
      description = "Openvswitch bridge interface.";
      default = "br0";
      type = types.str;
    };

    nodes = mkOption {
      description = "List of networks";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bridge-utils pkgs.tcpdump ];

    virtualisation.vswitch.ipsec = true;
    virtualisation.vswitch.enable = true;
    networking.firewall.allowedUDPPorts = [ 500 4500 ];
    systemd.services.ovsconfig = {
      wantedBy = [ "multi-user.target" ];
      after = [ "ovsMonitorIpsec.service" "network.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        export PATH=/var/run/current-system/sw/bin:$PATH

        # add ovs bridge
        ovs-vsctl --may-exist add-br obr0 -- set Bridge obr0 fail-mode=secure
        ovs-vsctl set bridge obr0 protocols=OpenFlow13

        # add tun device
        ovs-vsctl --may-exist add-port obr0 tun0 -- set Interface tun0 type=internal ofport_request=9

        brctl addif br0 tun0 || true
        ip link set tun0 up

        ovs-vsctl --may-exist add-port obr0 gre0 -- set Interface gre0 type=gre options:remote_ip="flow" options:key="flow" ofport_request=10

        # add oflow rules, because we do not want to use stp
        ovs-ofctl -O OpenFlow13 del-flows obr0

        # now loop through all other nodes and create persistent gre tunnels
        ovs-ofctl -O OpenFlow13 add-flow obr0 "table=0,nw_dst=${config.networking.interfaces.${cfg.interface}.ipAddress}/${toString config.networking.interfaces.${cfg.interface}.prefixLength},in_port=10,actions=output:9"
        ${concatStrings (imap (i: n: let
          net = n.config.networking;
          publicIPv4 = n.config.attributes.publicIPv4;
        in if publicIPv4 == config.attributes.publicIPv4 then ''
        '' else ''
          ovs-ofctl -O OpenFlow13 add-flow obr0 "table=0,in_port=9,nw_dst=${net.interfaces.${cfg.interface}.ipAddress}/${toString net.interfaces.${cfg.interface}.prefixLength},actions=set_field:${publicIPv4}->tun_dst,output:10"
        '') cfg.nodes)}
      '';
    };

  };
}
