{ config, pkgs, lib, ... }:

with lib;

{
  options.profiles.consul = {
    enable = mkEnableOption "Whether to enable consul profile.";
  };

  config = {
    services = mkIf config.profiles.consul.enable {
      consul = {
        enable = true;
        webUi = mkIf config.attributes.tags.master true;
        interface = {
          advertise = "eth0";
          bind = "eth0";
        };
        dropPrivileges = false;
        extraConfig = {
          server = if config.attributes.tags.master then true else false;
          bootstrap = if config.attributes.tags.master then true else false;
          services = attrValues (mapAttrs (n: s: {
            inherit (s) name port;
            address = s.host;
            checks = attrValues (mapAttrs (n: c: {
              inherit (c) name script interval;
            }) s.checks);
          }) config.attributes.services);
          retry_join = config.attributes.clusterNodes;
        };
        alerts.enable = config.attributes.tags.alerting;
      };
    };

    profiles.nginx.snippets.consul = ''
      location /ui {
        proxy_pass http://127.0.0.1:8500;
      }

      location /v1 {
        proxy_pass http://127.0.0.1:8500;
      }
    '';
  };
}
