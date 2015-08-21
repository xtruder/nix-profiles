{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.kube-vpn;

  kube-interface = config.profiles.kubernetes.network.interface;

in {
  options.profiles.kube-vpn = {
    enable = mkEnableOption "enable kubernese vpn access";

    vpnSubnet = mkOption {
      description = "Subnet for VPN.";
      default = "10.244.100.1 255.255.0.0 10.244.100.1 10.244.100.255";
    };

    serviceRoute = mkOption {
      description = "Route to access kubernetes services";
      default = "10.255.1.0 255.255.255.0 10.244.1.1";
    };

    searchDomain = mkOption {
      description = "Domain to search";
      default = config.attributes.domain;
    };

    dns = mkOption {
      description = "Kubernetes dns server";
      default = "10.244.1.1";
    };

    certPath = mkOption {
      description = "Path to server cert file.";
    };

    dhPath = mkOption {
      description = "Path to dh12 parameters";
      default = "/run/secrets/dh1024.pem";
    };

    interface = mkOption {
      description = "Vpn interface to create.";
      default = "kbr-vpn";
      type = types.str;
    };
  };

  config = mkIf (cfg.enable) {
    networking = {
      bridges.${kube-interface}.interfaces = [ cfg.interface ];
      interfaces = {
        ${cfg.interface} = {
          virtual = true;
          virtualType = "tap";
        };
      };
    };

    services.openvpn = {
      enable = true;
      servers.kubernetes = {
        config = ''
          dev ${cfg.interface}
          dev-type tap
          tls-server
          pkcs12 ${cfg.certPath}
          dh ${cfg.dhPath}
          server-bridge ${cfg.vpnSubnet}
          push "route ${cfg.serviceRoute}"
          push "dhcp-option DOMAIN ${cfg.searchDomain}"
          push "dhcp-option DNS ${cfg.dns}"
        '';
      };
    };
  };
}
