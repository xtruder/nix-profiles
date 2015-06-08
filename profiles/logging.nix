{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.logging;
  attrs = config.attributes;
in {
  options = {
    profiles.logging = {
      enable = mkEnableOption "Whether to enable logging profile.";

      prefix = mkOption {
        description = "Kibana nginx prefix.";
        default = "/kibana";
        type = types.str;
      };

      elasticsearch = {
        host = mkOption {
          description = "Host for elasticsearch.";
          type = types.str;
          default = "localhost";
        };

        port = mkOption {
          description = "Port for elasticsearch.";
          type = types.int;
          default = 9200;
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    services = {
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
            host => "${cfg.elasticsearch.host}"
            port => "${toString cfg.elasticsearch.port}"
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

    };

    profiles.nginx.upstreams = {
      elasticsearch = { servers = ["${cfg.elasticsearch.host}:${toString cfg.elasticsearch.port}"]; };
    };

    profiles.nginx.snippets.logging = ''
      location ${cfg.prefix} {
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

      location ~ ^/_aliases$ {
        proxy_pass http://elasticsearch;
      }
      location ~ ^/.*/_aliases$ {
        proxy_pass http://elasticsearch;
      }
      location ~ ^/_nodes$ {
        proxy_pass http://elasticsearch;
      }
      location ~ ^/.*/_search$ {
        proxy_pass http://elasticsearch;
      }
      location ~ ^/.*/_mapping {
        proxy_pass http://elasticsearch;
      }

      location ~ ^/kibana-int/dashboard/.*$ {
        proxy_pass http://elasticsearch;
      }
      location ~ ^/kibana-int/temp.*$ {
        proxy_pass http://elasticsearch;
      }
    '';
  };
}
