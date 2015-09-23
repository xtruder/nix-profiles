{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.consul;

in {
  options.profiles.consul = {
    enable = mkEnableOption "Whether to enable consul profile.";

    join = mkOption {
      description = "List of nodes to join";
      default = [];
    };

    upstreamDns = mkOption {
      description = "Upstream dns server.";
      default = config.attribute.nameservers;
    };
  };

  config = {
    services = mkIf config.profiles.consul.enable {
      consul = {
        enable = true;
        webUi = mkIf config.attributes.tags.master true;
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
          server = if config.attributes.tags.master then true else false;
          bootstrap = if config.attributes.tags.master then true else false;
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
          enable = config.attributes.tags.alerting;
          consulAddr = config.attributes.privateIPv4 + ":8500";
        };
      };
    };

    attributes.services.consul = mkIf config.attributes.tags.master {
      host = config.attributes.privateIPv4;
      port = 8500;
      proxy.enable = true;
    };
  };
}
