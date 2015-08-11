{ config, pkgs, lib, ... }:

with lib;

let
  logstash = config.profiles.logstash;
  attrs = config.attributes;

  journalInput = ''
    pipe {
      command => "${pkgs.systemd}/bin/journalctl -f -o json"
      type => "journal" codec => json {}
    }
  '';

  journalFilter = ''
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
in {
  options = {
    profiles.logstash = {
      enable = mkEnableOption "Whether to enable logstash master profile.";

      prefix = mkOption {
        description = "Kibana nginx prefix.";
        default = "/kibana";
        type = types.str;
      };

      elasticsearch = {
        bind_host = mkOption {
          description = "Host for elasticsearch.";
          type = types.str;
          default = config.attributes.privateIPv4;
        };

        bind_port = mkOption {
          description = "Port for elasticsearch.";
          type = types.int;
          default = 9400;
        };

        cluster_name = mkOption {
          description = "Elasticsearch cluster name.";
          default = config.attributes.projectName;
          type = types.str;
        };

        keystore = mkOption {
          description = "Keystore for logstash in JKS format";
          type = types.path;
        };
      };
    };
  };

  config = (mkMerge [(mkIf logstash.enable {
    services = {
      # Logstash for log aggregation
      logstash = {
        enable = true;
        plugins = [ pkgs.logstash-contrib ];
        logLevel = "error";
        inputConfig = ''
          ${journalInput}

          syslog {
            type => "syslog"
            codec => "json"
          }
        '';
        filterConfig = journalFilter;
        outputConfig = ''
          elasticsearch {
            cluster => "${logstash.elasticsearch.cluster_name}"
            bind_host => "${logstash.elasticsearch.bind_host}"
            bind_port => ${toString logstash.elasticsearch.bind_port}
            index => "logstash-%{+YYYY.MM.dd}"
            protocol => "node"
          }
        '';
        #keystore => "${logstash.elasticsearch.keystore}"
      };

    };

  })]);
}
