{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.metrics;
  attrs = config.attributes;

in {
  options = {
    profiles.metrics = {
      enable = mkEnableOption "Whether to enable monitoring profile.";

      graphite = {
        host = mkOption {
          description = "Host for graphite.";
          type = types.str;
          default = "localhost";
        };

        port = mkOption {
          description = "Port for graphite.";
          type = types.int;
          default = 2003;
        };
      };

      influxdb = {
        enable = mkOption {
          description = "Whether to enable influxdb.";
          type = types.bool;
          default = config.attributes.tags.storage;
        };

        db = mkOption {
          description = "Influxdb database.";
          type = types.str;
          default = "stats";
        };
     };

      grafana = {
        enable = mkOption {
          description = "Whether to enable grafana.";
          type = types.bool;
          default = config.attributes.tags.master;
        };

        domain = mkOption {
          description = "Grafana domain.";
          type = types.str;
          default = "grafana.${config.networking.domain}";
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [
      pkgs.influxdb-backup
    ];

    services = {
      graphite = mkIf attrs.tags.master {
        api = {
          enable = mkDefault true;
          host = "0.0.0.0";
          port = 8082;
          finders = [ pkgs.python27Packages.graphite_influxdb ];
          extraConfig = ''
            allowed_origins:
              - stats
            cheat_times: true
            influxdb:
              host: ${cfg.graphite.host}
              port: ${toString cfg.graphite.port}
              db: ${cfg.influxdb.db}
              user: root
              pass: root
            cache:
              CACHE_TYPE: 'filesystem'
              CACHE_DIR: '/tmp/graphite-api-cache'
          '';
          package = pkgs.python27Packages.graphite_api.override {
            src = pkgs.fetchgit {
              url = https://github.com/offlinehacker/graphite-api.git;
              rev = "ee50031a42d63cb1b0e9aa0a157716c91e1423d7";
              sha256 = "f37437eb0faab9312b953c09c06e5fa8f886e94c3b323679f71a0de1622b1919";
            };
          };
        };

        #seyren.enable = mkIf attrs.tags.master true;
      };

      influxdb = {
        enable = cfg.influxdb.enable;
        bindAddress = config.attributes.privateIPv4;
        inputPluginsConfig = ''
          [input_plugins.graphite]
          enabled = true
          port = 2003
          database = "${cfg.influxdb.db}"
        '';
      };

      grafana.enable = cfg.grafana.enable;
      grafana.addr = config.attributes.privateIPv4;

      collectd = {
        enable = mkDefault true;
        user = "root"; # some commands are privileged
        extraConfig = ''
          LoadPlugin ping
          LoadPlugin df
          LoadPlugin memory
          LoadPlugin load
          LoadPlugin cpu
          LoadPlugin interface
          LoadPlugin "write_graphite"

          <Plugin ping>
            Host "localhost"
          </Plugin>

          <Plugin "write_graphite">
            <Node "example">
              Host "${cfg.graphite.host}"
              Port "${toString cfg.graphite.port}"
              Prefix "collectd."
              EscapeCharacter "_"
              SeparateInstances true
              StoreRates false
              AlwaysAppendDS false
            </Node>
          </Plugin>

          <Plugin "df">
            Device "/dev/disk/by-label/nixos"
            MountPoint "/"
          </Plugin>

          <Plugin nginx>
            URL "http://localhost/nginx_status"
          </Plugin>

          <Plugin interface>
            Interface "eth0"
            IgnoreSelected false
          </Plugin>
        '';
      };
    };

    attributes.services.grafana = mkIf cfg.grafana.enable {
      host = config.attributes.privateIPv4;
      port = config.services.grafana.port;
      proxy.enable = true;
    };

    attributes.services.influxdb-api = mkIf cfg.influxdb.enable {
      host = config.attributes.privateIPv4;
      port = config.services.influxdb.apiPort;
      proxy.enable = true;
    };

    attributes.services.influxdb = mkIf cfg.influxdb.enable {
      host = config.attributes.privateIPv4;
      port = config.services.influxdb.adminPort;
      proxy.enable = true;
    };
  };
}
