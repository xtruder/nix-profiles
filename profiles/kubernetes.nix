{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.kubernetes;

in {
  options.profiles.kubernetes = {
    enable = mkEnableOption "Whether to enable kubernetes profile.";

    master = mkOption {
      description = "Wheter node is master";
      default = pkgs.lib.elem "master" config.attributes.tags;
      type = types.bool;
    };

    node = mkOption {
      description = "Wheter node is a compute node";
      default = pkgs.lib.elem "compute" config.attributes.tags;
      type = types.bool;
    };

    tokens = mkOption {
      description = "Attribute set of username and passwords";
      default = {};
      type = types.attrs;
    };

    registries = mkOption {
      type = types.listOf types.optionSet;
      description = "Attribute set of docker registries";
      options = {
        url = mkOption {
          description = "Docker registry url";
          type = types.str;
        };

        email = mkOption {
          description = "Docker registry email";
          type = types.str;
          default = "";
        };

        auth = mkOption {
          description = "Docekr registry auth.";
          type = types.str;
          default = "";
        };
      };
    };

    #influxdb = {
      #host = mkOption {
        #description = "influxdb host for cadvisor";
        #type = types.str;
        #default = "localhost";
      #};

      #port = mkOption {
        #description = "influxdb port for cadvisor";
        #type = types.int;
        #default =
      #};
    #};

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
          iptables -A nixos-fw -p udp --dport 53 -i kbr -m comment --comment "allow skydns on kubernetes network"  -j nixos-fw-accept
          iptables -A nixos-fw -p tcp --dport 53 -i kbr -m comment --comment "allow skydns on kubernetes network"  -j nixos-fw-accept
          iptables -A nixos-fw -p tcp --dport 6443 -i kbr -m comment --comment "allow kubernetes on kubernetes network"  -j nixos-fw-accept
        '';
      };
    };

    services = {
      kubernetes = {
        dockerCfg = builtins.toJSON (listToAttrs (map (registry: nameValuePair registry.url {
          email = registry.email;
          auth = registry.auth;
        }) cfg.registries));
        etcdServers = ["${config.attributes.privateIPv4}:4001"];
        roles =
          (optionals cfg.master ["master"]) ++
          (optionals cfg.node ["node"]);

        apiserver = {
          address = "0.0.0.0";
          publicAddress = cfg.network.ipAddress;
          tokenAuth = cfg.tokens;
          portalNet = cfg.network.servicesSubnet;
          admissionControl = ["NamespaceLifecycle" "NamespaceExists" "LimitRanger" "SecurityContextDeny" "ServiceAccount" "ResourceQuota"];
          allowPrivileged = true;
        };

        kubelet = {
          address = mkDefault config.attributes.privateIPv4;
          hostname = mkDefault config.attributes.privateIPv4;
          clusterDns = cfg.network.ipAddress;
          clusterDomain = config.attributes.domain;
        };
      };

      skydns.address = cfg.network.ipAddress + ":53";
      skydns.domain = cfg.network.domain;
      skydns.nameservers =
        map (v: v + ":53") config.attributes.nameservers;

      heapster.enable = cfg.master;
      heapster.source = "kubernetes:http://" + config.services.kubernetes.proxy.master + "?useServiceAccount=false&auth=&insecure=true";
      heapster.sink = "influxdb:http://localhost:8086";
    };

    systemd.services.skydns.serviceConfig = {
      Restart = "always";
      RestartSec = "30s";
      OOMScoreAdjust = -500;
    };
    systemd.services.kubelet.serviceConfig = {
      Restart = "always";
      RestartSec = "30s";
      OOMScoreAdjust = -500;
    };
    systemd.services.kube-apiserver.serviceConfig = {
      Restart = "always";
      RestartSec = "30s";
      OOMScoreAdjust = -500;
    };
    systemd.services.kube-controller-manager.serviceConfig = {
      Restart = "always";
      RestartSec = "30s";
      OOMScoreAdjust = -500;
    };
    systemd.services.kube-scheduler.serviceConfig = {
      Restart = "always";
      RestartSec = "30s";
      OOMScoreAdjust = -500;
    };
    systemd.services.docker.serviceConfig = {
      Restart = "always";
      RestartSec = "30s";
    };

    systemd.services.docker-gc = {
      description = "Garbage collect docker images";
      wantedBy = [ "multi-user.target" ];
      after = ["docker.service"];
      startAt = "*-*-* 00:00:00";
      serviceConfig.Restart = "no";
      serviceConfig.User    = "root";
      script = ''
        ${pkgs.docker-gc}/bin/docker-gc
      '';
    };

    virtualisation.docker.extraOptions =
      ''--iptables=false --ip-masq=false -b ${cfg.network.interface} --log-level="warn"'';

    virtualisation.docker.storageDriver = "overlay";

    attributes.services.kubernetes = {
      host = cfg.network.ipAddress;
      port = 8080;
      checkFailure = ["etcd" "kubelet" "skydns" "kube-controller-manager" "kube-apiserver" "kube-scheduler" "kube-proxy"];
    };
  };
}
