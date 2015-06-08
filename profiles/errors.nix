# Error monitoring using sentry

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.sentry;
  attrs = config.attributes;
in {
  options.profiles.sentry = {
    enable = mkEnableOption "Whether to enable sentry error monitoring.";

    prefix = mkOption {
      description = "Url prefix that sentry will listen.";
      type = types.str;
      default = "/sentry";
    };
  };

  config.profiles.sentry = mkIf cfg.enable {
    sentry = {
      enable = true;
      url = mkDefault "http://${config.networking.hostName}${cfg.prefix}";
      prefix = mkDefault cfg.prefix;
    };

    services.consul = {
      port = 9000;
    };
    consul.extraConfig.services = mkIf (
      attrs.monitoring && attrs.checkWith == "consul"
    ) [{
      name = "sentry";
      port = 9000;
      address = "127.0.0.1";
      checks = [{
        name = "active";
        script = "/var/run/current-system/sw/bin/systemctl is-active sentry";
        interval = "10s";
      }];
    }];

    profiles.nginx.snippets.sentry = ''
      location /${cfg.prefix}/ {
        proxy_pass         http://localhost:9000/;
      }
    '';
  };
}
