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
        joinNodes = config.attributes.clusterNodes;
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
        };
        alerts = {
          enable = config.attributes.tags.alerting;
          package = overrideDerivation pkgs.consul-alerts (p:{
            src = pkgs.fetchFromGitHub {
              owner = "offlinehacker";
              repo = "consul-alerts";
              rev = "hipchat";
              sha256 = "19x1acdnd8c1vwagjb499wmilpvbfgn5n6wvy74dlk8qv29cjvb9";
            };
          });
        };
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
