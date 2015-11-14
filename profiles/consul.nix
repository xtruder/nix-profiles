{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.consul;

in {
  options.profiles.consul = {
    enable = mkEnableOption "Whether to enable consul profile.";

    join = mkOption {
      description = "List of nodes to join";
      default = mkDefault config.attributes.clusterNodes;
    };

    alerts = mkOption {
      description = "Whether to enable consul alerts";
      default = elem "master" config.attributes.tags;
    };

    upstreamDns = mkOption {
      description = "Upstream dns server.";
      default = config.attributes.nameservers;
    };
  };

  config = mkIf config.profiles.consul.enable {
    systemd.services.consul.serviceConfig.Restart = "always";
    systemd.services.consul.serviceConfig.RestartSec = "30s";

    services = {
      consul = {
        enable = true;
        webUi = mkDefault (elem "master" config.attributes.tags);
        dropPrivileges = false;
        extraConfig = {
          advertise_addr = config.attributes.privateIPv4;
          bind_addr = config.attributes.privateIPv4;
          addresses = {
            dns = config.attributes.privateIPv4;
            http = config.attributes.privateIPv4;
          };
          ports = {
            dns = 53;
          };
          server = if (elem "master" config.attributes.tags) then true else false;
          bootstrap = if (elem "leader" config.attributes.tags) then true else false;
          services = attrValues (mapAttrs (n: s: {
            inherit (s) name port;
            address = s.host;
            checks = attrValues (mapAttrs (n: c: {
              notes = c.name;
              inherit (c) name script interval;
            }) s.checks);
          }) config.attributes.services);
          retry_join = cfg.join;
          recursors = [cfg.upstreamDns];
          domain = config.networking.domain;
        };
        alerts = {
          listenAddr = "0.0.0.0:9000";
          enable = true;
          consulAddr = config.attributes.privateIPv4 + ":8500";
        };
      };
    };

    attributes.services.consul = mkIf (elem "master" config.attributes.tags) {
      host = config.attributes.privateIPv4;
      port = 8500;
      proxy.enable = true;
    };
  };
}
