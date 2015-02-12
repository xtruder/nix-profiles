{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.monitoring;

in {
  options = {
    profiles.monitoring = {
      enable = mkOption {
        description = "Whether to enable monitoring profile.";
        default = false;
        type = types.bool;
      };

      nodes = mkOption {
        description = "List of nodes to monitor.";
        default = [];
        type = types.listOf types.str;
      };

      role = mkOption {
        description = "Monitoring role (client or server).";
        type = types.enum ["client" "server"];
        default = "server";
      };

      checks = mkOption {
        description = "Which services to check with consul.";
        type = types.listOf types.str;
        default = [];
      };

      server = mkOption {
        description = "Host for graphite.";
        type = types.str;
        default = "localhost";
      };
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [
      pkgs.influxdb-backup
    ];

    services = {

      # Graphs
      graphite = mkIf (cfg.role == "server") {
        api = {
          enable = true;
          host = "0.0.0.0";
          finders = [ pkgs.python27Packages.graphite_influxdb ];
          extraConfig = ''
            allowed_origins:
              - stats
            cheat_times: true
            influxdb:
              host: localhost
              port: 8086
              user: root
              pass: root
              db: stats
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

        # Alerting dashboard
        seyren.enable = true;
      };

      # Database for stats aggregation
      influxdb = mkIf (cfg.role == "server") {
        enable = true;
        bindAddress = "0.0.0.0";
        inputPluginsConfig = ''
          [input_plugins.graphite]
          enabled = true
          port = 2003
          database = "stats"
        '';
      };

      # For system status
      consul = {
        enable = true;
        webUi = mkIf (cfg.role == "server") true;
        joinNodes = cfg.nodes;
        dropPrivileges = false;
        extraConfig = mkIf (cfg.role == "server") {
          server = true;
          bootstrap = true;
        };
        alerts.enable = mkIf (cfg.role == "server") true;
      };

      statsd = mkIf (cfg.role == "client") {
        enable = true;
        backends = [ "graphite" ];
        graphiteHost = cfg.server;
        graphitePort = 2003;
      };

      # For alerts
      #sentry = mkIf (cfg.role == "server") {
        #enable = true;
        #url = mkDefault "http://${config.networking.hostName}/sentry";
        #prefix = mkDefault "/sentry";
      #};

      # Database for log aggregation
      elasticsearch = mkIf (cfg.role == "server") {
        enable = true;
        host = "0.0.0.0";
      };

      collectd = {
        enable = true;
        user = "root"; # some commands are privileged
        extraConfig = ''
          LoadPlugin ping
          LoadPlugin df
          LoadPlugin nginx
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
              Host "${cfg.server}"
              Port "2003"
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

      # Logstash for log aggregation
      logstash = {
        enable = true;
        plugins = [ pkgs.logstash-contrib ];
        inputConfig = ''
          pipe {
            command => "${pkgs.systemd}/bin/journalctl -f -o json"
            type => "journal" codec => json {}
          }

          syslog {
            type => "syslog"
            codec => "json"
          }
        '';
        outputConfig = ''
          elasticsearch_http {
            host => "${cfg.server}"
            port => "${toString config.services.elasticsearch.port}"
            index => "logstash-%{+YYYY.MM.dd}"
          }
        '';
        filterConfig = ''
          if [type] == "journal" {
            # Keep only relevant systemd fields
            # http://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
            prune {
              whitelist_names => [
                "type", "@timestamp", "@version",
                "MESSAGE", "PRIORITY", "SYSLOG_FACILITY",
                "_PID", "_UID", "_GID", "_EXE", "_CMDLINE"
              ]
            }
          }
        '';
      };

      postgresql.package = pkgs.postgresql92;
      postgresql.authentication = mkIf (cfg.role == "server") ''
        host sentry sentry localhost trust
      '';
    };

    systemd.services.influxdb.postStart = mkIf (cfg.role == "server") ''
      export PORT=${toString config.services.influxdb.apiPort}
      export PATH=${pkgs.curl}/bin:$PATH

      # Add stats database
      curl -s -o /dev/null  -X POST "http://localhost:$PORT/db?u=root&p=root" \
        -d '{"name": "stats"}' || true
    '';

    profiles.nginx.snippets.monitoring = ''
      location /grafana {
        alias ${pkgs.grafana.override {
          conf = pkgs.writeText "config.js" ''
          define(['settings'],
          function (Settings) {
            return new Settings({
              datasources: {
                graphite: {
                  type: 'graphite',
                  url: window.location.protocol+"//"+window.location.hostname+":"+window.location.port,
                },
                elasticsearch: {
                  type: 'elasticsearch',
                  url: window.location.protocol+"//"+window.location.hostname+":"+window.location.port,
                  index: 'grafana-dash',
                  grafanaDB: true,
                }
              },

              search: {
                max_results: 20
              },

              // default home dashboard
              default_route: '/dashboard/file/default.json',

              // set to false to disable unsaved changes warning
              unsaved_changes_warning: true,

              // set the default timespan for the playlist feature
              // Example: "1m", "1h"
              playlist_timespan: "1m",

              // If you want to specify password before saving, please specify it bellow
              // The purpose of this password is not security, but to stop some users from accidentally changing dashboards
              admin: {
                password: ""
              },

              // Change window title prefix from 'Grafana - <dashboard title>'
              window_title_prefix: 'Grafana - euganke',
            })
          })'';
        }};

        expires 30d;
        access_log off;
      }

      location /kibana {
        alias ${pkgs.kibana.override {
          conf = pkgs.writeText "config.js" ''
            define(['settings'],
            function (Settings) {
              return new Settings({
                elasticsearch: window.location.protocol+"//"+window.location.hostname+":"+window.location.port,
                default_route: '/dashboard/file/default.json',
                kibana_index: "kibana-int",
                panel_names: [
                  'histogram',
                  'map',
                  'goal',
                  'table',
                  'filtering',
                  'timepicker',
                  'text',
                  'hits',
                  'column',
                  'trends',
                  'bettermap',
                  'query',
                  'terms',
                  'stats',
                  'sparklines'
                ]
              })
            })
          '';}};

        expires 30d;
        access_log off;
      }

      location /ui {
        proxy_pass http://127.0.0.1:8500;
      }

      location /v1 {
        proxy_pass http://127.0.0.1:8500;
      }

      #location /sentry/ {
        #proxy_pass         http://localhost:9000/;
      #}

      location /seyren {
        proxy_pass http://127.0.0.1:8081;
        rewrite /seyren(.*) /$1  break;
      }

      # Kibana proxy passes
      location ~ ^/_aliases$ {
        proxy_pass http://127.0.0.1:9200;
      }
      location ~ ^/.*/_aliases$ {
        proxy_pass http://127.0.0.1:9200;
      }
      location ~ ^/_nodes$ {
        proxy_pass http://127.0.0.1:9200;
      }
      location ~ ^/.*/_search$ {
        proxy_pass http://127.0.0.1:9200;
      }
      location ~ ^/.*/_mapping {
        proxy_pass http://127.0.0.1:9200;
      }

      location ~ ^/kibana-int/dashboard/.*$ {
        proxy_pass http://127.0.0.1:9200;
      }
      location ~ ^/kibana-int/temp.*$ {
        proxy_pass http://127.0.0.1:9200;
      }

      # Grafana proxy passes
      location ~ ^/(metrics|events|dashboard)/.*$ {
        proxy_pass http://127.0.0.1:8080;
      }

      location ~ ^/(render|index)$ {
        proxy_pass http://127.0.0.1:8080;
      }

      location ~ ^/grafana-dash/dashboard/.*$ {
        proxy_pass http://127.0.0.1:9200;
      }
      location ~ ^/grafana-dash/temp.*$ {
        proxy_pass http://127.0.0.1:9200;
      }
    '';

    environment.etc = mkMerge (map (service: {
      "consul.d/${service}.json".text = ''
        {"check": {
          "name": "${service}",
          "script": "/var/run/current-system/sw/bin/systemctl is-active ${service}",
          "interval": "10s"
        }}
      '';
    }) cfg.checks);
    services.consul.extraConfigFiles = map (service: "/etc/consul.d/${service}.json") cfg.checks;

  };
}
