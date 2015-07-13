{ config, lib, pkgs, nodes, ... }: with lib;

let
  cfg = config.profiles.kubernetes;

in {
  options.profiles.kubernetes = {
    enable = mkEnableOption "Whether to enable kubernetes profile.";

    master = mkOption {
      description = "Wheter node is master";
      default = false;
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

    servicesSubnet = mkOption {
      description = "Subnet for services.";
      default = "10.255.1.0/24";
      type = types.str;
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    services = {
      nodeDockerRegistry.enable = mkDefault true;
      nodeDockerRegistry.port = mkDefault 5000;

      kubernetes = {
        roles =
          (optionals cfg.master ["master"]) ++
          (optionals cfg.node ["node"]);

        # If running a master join all compute nodes
        controllerManager.machines =
          map (n: n.config.attributes.privateIPv4)
          (filter (n: n.config.attributes.tags.compute) (attrValues nodes));
        apiserver = {
          address = "0.0.0.0";
          tokenAuth = cfg.tokens;
          portalNet = cfg.servicesSubnet;
        };

        kubelet = {
          hostname = config.attributes.privateIPv4;
          clusterDns = config.attributes.privateIPv4;
          clusterDomain = config.attributes.domain;
        };

        reverseProxy.enable = true;
        logging.enable = true;
      };

      skydns.domain = config.attributes.domain;
    };

    virtualisation.docker.extraOptions =
      ''--iptables=false --ip-masq=false -b br0 --log-level="warn"'';
  }]);
}
