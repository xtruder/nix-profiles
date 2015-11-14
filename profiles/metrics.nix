{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.metrics;
  attrs = config.attributes;

in {
  options = {
    profiles.metrics = {
      enable = mkEnableOption "Whether to enable monitoring profile.";

      influxdb = {
        enable = mkOption {
          description = "Whether to enable influxdb.";
          type = types.bool;
          default = true;
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
          default = true;
        };

        domain = mkOption {
          description = "Grafana domain.";
          type = types.str;
          default = "grafana.${config.networking.domain}";
        };
      };

      bosun = {
        enable = mkOption {
          description = "Whether to enable bosun";
          type = types.bool;
          default = true;
        };

        influxHost = mkOption {
          description = "Influxdb host";
          type = types.str;
          default = "localhost:8086";
        };

        emailTo = mkOption {
          description = "List of addresses to send email to";
          type = types.listOf types.str;
          default = [];
        };

        smtp = {
          username = mkOption {
            description = "Username for smtp server";
            type = types.str;
          };

          password = mkOption {
            description = "Password for smtp server";
            type = types.str;
          };

          host = mkOption {
            description = "Smtp host";
            type = types.str;
            default = "smtp.gmail.com:587";
          };

          emailFrom = mkOption {
            description = "Smtp email address";
            type = types.str;
          };
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [
      pkgs.influxdb-backup
    ];

    services = {
      influxdb = {
        enable = cfg.influxdb.enable;
        extraConfig = {
          collectd = {
            enabled = true;
          };
        };
      };

      bosun.enable = cfg.bosun.enable;
      bosun.checkFrequency = "15s";
      bosun.extraConfig = ''
        timeAndDate = 202,75,179,136
        influxHost = ${cfg.bosun.influxHost}
        smtpHost = ${cfg.bosun.smtp.host}
        smtpUsername = ${cfg.bosun.smtp.username}
        smtpPassword = ${cfg.bosun.smtp.password}
        emailFrom = ${cfg.bosun.smtp.emailFrom}

        notification default {
          email = ${concatStringsSep "," cfg.bosun.emailTo}
          next = default
          timeout = 1h
          print = true
        }

        template generic {
          body = `<a href="{{.Ack}}">Acknowledge alert</a>
          <p>Alert definition:
          <p>Name: {{.Alert.Name}}
          <p>Crit: {{.Alert.Crit}}

          <p>Tags

          <table>
            {{range $k, $v := .Group}}
              {{if eq $k "host"}}
                <tr><td>{{$k}}</td><td><a href="{{$.HostView $v}}">{{$v}}</a></td></tr>
              {{else}}
                <tr><td>{{$k}}</td><td>{{$v}}</td></tr>
              {{end}}
            {{end}}
          </table>`
          subject = {{.Last.Status}}: {{.Alert.Name}}: {{.Eval .Alert.Vars.q}} on {{.Group.host}}
        }

        alert os.high.cpu {
          template = generic
          warnNotification = default
          critNotification = default
          $db = "collectd_db"
          $q = avg(influx("collectd_db", "SELECT mean(value) FROM load_midterm GROUP BY host", "1m", "", ""))
          warn = $q > 3
          crit = $q > 4
        }

        alert os.high.disk {
          template = generic
          warnNotification = default
          critNotification = default
          $db = "collectd_db"
          $q = avg(influx("collectd_db", "SELECT value FROM df_value WHERE instance =~ /xv.*/ AND type_instance = 'free' AND type = 'df_complex' GROUP BY instance, host", "1m", "", ""))
          warn = $q < 200000000
          crit = $q < 100000000
        }

        alert os.test.alerts {
          template = generic
          warnNotification = default
          critNotification = default
          $db = "collectd_db"
          $q = avg(influx("collectd_db", "SELECT last(value) FROM test", "1d", "", ""))
          warn = $q > 1
          crit = $q > 3
        }
      '';

      grafana.enable = cfg.grafana.enable;
      grafana.addr = config.attributes.privateIPv4;
    };

    attributes.services.bosun = mkIf cfg.bosun.enable {
      host = config.attributes.privateIPv4;
      port = 8070;
      proxy.enable = true;
    };

    attributes.services.influxdb-api = mkIf cfg.influxdb.enable {
      host = config.attributes.privateIPv4;
      port = 8086;
      proxy.enable = true;
    };

    attributes.services.influxdb = mkIf cfg.influxdb.enable {
      host = config.attributes.privateIPv4;
      port = 8083;
      proxy.enable = true;
    };

    attributes.services.grafana = mkIf cfg.grafana.enable {
      host = config.attributes.privateIPv4;
      port = 3000;
      proxy.enable = true;
    };
  };
}
