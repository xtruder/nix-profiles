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
        db = mkOption {
          description = "Influxdb database.";
          type = types.str;
          default = "stats";
        };
      };

      grafana.prefix = mkOption {
        description = "URL prefix for grafana.";
        type = types.str;
        default = "/grafana";
      };

      seyren.prefix = mkOption {
        description = "URL prefix for seyren.";
        type = types.str;
        default = "/seyren";
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
        enable = mkDefault true;
        inputPluginsConfig = ''
          [input_plugins.graphite]
          enabled = true
          port = 2003
          database = "${cfg.influxdb.db}"
        '';
      };

      grafana = {
        enable = true;
        rootUrl = "%(protocol)s://%(domain)s:%(http_port)s${cfg.grafana.prefix}";
      };

      statsd = {
        enable = mkDefault true;
        backends = [ "graphite" ];
        graphiteHost = cfg.graphite.host;
        graphitePort = cfg.graphite.port;
      };

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

    systemd.services.influxdb.postStart = ''
      export PORT=${toString config.services.influxdb.apiPort}
      export PATH=${pkgs.curl}/bin:$PATH

      # Add stats database
      curl -s -o /dev/null  -X POST "http://localhost:$PORT/db?u=root&p=root" \
        -d '{"name": "stats"}' || true
    '';

    profiles.nginx.upstreams = {
      grafana = { servers = [ "127.0.0.1:3000"]; };
      seyren = { servers = [ "127.0.0.1:8081" ]; };
      graphite-api = { servers = [ "127.0.0.1:8082" ]; };
    };

    profiles.nginx.snippets.monitoring = ''
      location ${cfg.grafana.prefix} {
        proxy_pass http://grafana;
        include ${config.profiles.nginx.snippets.proxy};
        rewrite ${cfg.grafana.prefix}(.*) $1  break;
      }

      location ${cfg.seyren.prefix} {
        proxy_pass http://seyren;
        rewrite ${cfg.seyren.prefix}(.*) /$1  break;
      }
    '';
  };
}
