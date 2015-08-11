{ config, lib, pkgs, nodes, ... }:

with lib;

let
  cfg = config.profiles.kubernetes;

in {
  options.profiles.kubernetes = {
    enable = mkEnableOption "Whether to enable kubernetes profile.";

    master = mkOption {
      description = "Wheter node is master";
      default = config.attributes.tags.master;
      type = types.bool;
    };

    node = mkOption {
      description = "Wheter node is a compute node";
      default = config.attributes.tags.compute;
      type = types.bool;
    };

    tokens = mkOption {
      description = "Attribute set of username and passwords";
      default = {};
      type = types.attrs;
    };

    registry = {
      url = mkOption {
        description = "Docker registry url.";
        type = types.str;
        default = "";
      };

      auth = mkOption {
        description = "Docekr registry auth.";
        type = types.str;
        default = "";
      };
    };

    network = {
      interface = mkOption {
        description = "Kubernetes interface.";
        default = "kbr";
        type = types.str;
      };

      ipAddress = mkOption {
        description = "Ip address for kubernetes network.";
        default = "10.244.1.1";
        type = types.str;
      };

      prefixLength = mkOption {
        description = "Kubernetes network prefix length.";
        default = 24;
        type = types.int;
      };

      subnet = mkOption {
        description = "Kubernetes network subnet.";
        default = "10.244.0.0/16";
        type = types.str;
      };

      servicesSubnet = mkOption {
        description = "Subnet for services.";
        default = "10.255.1.0/24";
        type = types.str;
      };

      domain = mkOption {
        description = "Kubernetes domain name for skydns.";
        default = config.attributes.domain;
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      # Use skydns for dns resolver
      nameservers = mkDefault [ "127.0.0.1" ];

      bridges.${cfg.network.interface} = mkDefault {
        interfaces = [];
      };
      interfaces.${cfg.network.interface} = {
        ipAddress = cfg.network.ipAddress;
        prefixLength = cfg.network.prefixLength;
      };
      localCommands = ''
        ip route add ${cfg.network.subnet} dev ${cfg.network.interface} || true
        ip route flush cache
      '';
      firewall = {
        allowedTCPPortRanges = [{from = 10000; to = 65535;}];
        extraCommands = ''
          iptables -A nixos-fw -p udp --dport 53 -i kbr -j nixos-fw-accept
          iptables -A nixos-fw -p tcp --dport 53 -i kbr -j nixos-fw-accept
          iptables -A nixos-fw -p tcp --dport 6443 -i kbr -j nixos-fw-accept
        '';
      };
    };

    services = {
      kubernetes = {
        dockerCfg = mkIf (cfg.registry.url != "" && cfg.registry.auth != "") ''
          {
            "${cfg.registry.url}": {
              "auth": "${cfg.registry.auth}",
              "email": ""
            }
          }
        '';
        etcdServers = ["${config.attributes.privateIPv4}:4001"];
        roles =
          (optionals cfg.master ["master"]) ++
          (optionals cfg.node ["node"]);

        # If running a master join all compute nodes
        controllerManager.machines =
          map (n: n.config.attributes.privateIPv4)
          (filter (n: n.config.attributes.tags.compute) (attrValues nodes));

        apiserver = {
          address = "0.0.0.0";
          publicAddress = cfg.network.ipAddress;
          tokenAuth = cfg.tokens;
          portalNet = cfg.network.servicesSubnet;
        };

        kubelet = {
          hostname = config.attributes.privateIPv4;
          clusterDns = cfg.network.ipAddress;
          clusterDomain = config.attributes.domain;
        };

        reverseProxy.enable = true;
        logging.enable = true;
      };

      skydns.address = cfg.network.ipAddress + ":53";
      skydns.domain = cfg.network.domain;
      skydns.nameservers =
        map (v: v + ":53") config.attributes.nameservers;
    };

    virtualisation.docker.extraOptions =
      ''--iptables=false --ip-masq=false -b ${cfg.network.interface} --log-level="warn"'';

    attributes.services.kubernetes = {
      host = cfg.network.ipAddress;
      port = 8080;
      checks = mkMerge [{
        kubelet = {
          script = "/var/run/current-system/sw/bin/systemctl is-active kubelet";
          interval = "10s";
        };
        kube-proxy = {
          script = "/var/run/current-system/sw/bin/systemctl is-active kube-proxy";
          interval = "10s";
        };
        skydns = {
          script = "/var/run/current-system/sw/bin/systemctl is-active skydns";
          interval = "10s";
        };
      }
      (mkIf config.attributes.tags.master {
        kube-apiserver = {
          script = "/var/run/current-system/sw/bin/systemctl is-active kube-apiserver";
          interval = "10s";
        };
        kube-controller-manager = {
          script = "/var/run/current-system/sw/bin/systemctl is-active kube-controller-manager";
          interval = "10s";
        };
        kube-scheduler = {
          script = "/var/run/current-system/sw/bin/systemctl is-active kube-scheduler";
          interval = "10s";
        };
      })];
    };
  };
}
