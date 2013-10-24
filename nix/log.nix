{ config, pkgs, ... }:
{
  services.logstash.inputConfig = ''
    # Read from journal
    pipe {
      command => "${pkgs.systemd}/bin/journalctl -f -o json"
      type => "syslog"
      codec => json {}
    }
  '';
  services.logstash.filterConfig =
  let
    # Translate syslog priorities
    # http://en.wikipedia.org/wiki/Syslog#Severity_levels
    priority2levelname = ''
      "0", "EMERGENCY", "1", "ALERT", "2", "CRITICAL", "3", "ERROR", "4", "WARNING",
      "5", "NOTICE", "6", "INFO", "7", "DEBUG"
    '';
    levelname2priority = ''
      "EMERGENCY", 0, "ALERT", 1, "CRITICAL", 2,  "ERROR", 3, "WARNING", 4,
      "NOTICE", 5, "INFO", 6, "DEBUG", 7
    '';
  in ''
    if "processed" in [tags] {
      noop {}
    } else {
      if [type] == "syslog" {
        # Keep only relevant systemd fields
        # http://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
        prune {
          whitelist_names => [
            "type", "@timestamp", "@version",
            "MESSAGE", "PRIORITY", "SYSLOG_FACILITY",
            "_HOSTNAME", "_PID", "_UID", "_GID", "_EXE", "_CMDLINE", "_SYSTEMD_UNIT",
            "CODE_FILE", "CODE_FUNCTION", "CODE_LINE"
          ]
        }

        # Translate syslog facilities
        # http://en.wikipedia.org/wiki/Syslog#Facility_Levels
        translate {
          field => "SYSLOG_FACILITY"
          dictionary => [ "0", "kern",
                          "1", "user",
                          "2", "mail",
                          "3", "daemon",
                          "4", "auth",
                          "5", "syslog",
                          "6", "lpr",
                          "7", "news",
                          "8", "uucp",
                          "9", "clock",
                          "10", "authpriv",
                          "11", "ftp",
                          "12", "ntp",
                          "13", "log_audit",
                          "14", "log_alert",
                          "15", "cron",
                          "16", "local0", "17", "local1", "18", "local2",
                          "19", "local3", "20", "local4", "21", "local5",
                          "22", "local6", "23", "local7" ]
          destination => "logger"
          remove_field => "SYSLOG_FACILITY"
        }

        # Mutate syslog fields
        mutate {
          rename => [ "MESSAGE", "message" ]
          rename => [ "_HOSTNAME", "host" ]
          rename => [ "PRIORITY", "priority" ]
          rename => [ "_SYSTEMD_UNIT", "unit" ]

          rename => [ "_PID", "[proc][pid]" ]
          rename => [ "_UID", "[proc][uid]" ]
          rename => [ "_GID", "[proc][gid]" ]
          rename => [ "_EXE", "[proc][exe]" ]
          rename => [ "_CMDLINE", "[proc][cmdline]" ]
          rename => [ "CODE_FILE", "[proc][file]" ]
          rename => [ "CODE_FUNCTION", "[proc][function]" ]
          rename => [ "CODE_LINE", "[proc][line]" ]

          convert => [ "priority", "integer" ]
          convert => [ "[proc][pid]", "integer" ]
          convert => [ "[proc][uid]", "integer" ]
          convert => [ "[proc][gid]", "integer" ]
        }

        # Translate priority to levelname
        translate {
          field => "priority"
          dictionary => [ ${priority2levelname} ]
          destination => "levelname"
        }

        # Join multiline java exception messages use pid as stream identifier
        multiline {
          pattern => "(^.+Exception: .+)|(^\s*at .+)|(^\s*... \d+ more)|(^\s*Caused by:.+)"
          what => "previous"
          stream_identity => "%{[proc][pid]}"
        }

        # Join multiline python exception messages use pid as stream identifier
        multiline {
          pattern => "^\[.+?\]\t+.*"
          what => "previous"
          stream_identity => "%{[proc][pid]}"
        }

        # Jsonify nginx messages
        if [unit] == "nginx.service" {
          json { source => "message" target => "info" }
          mutate { replace => ["message", "%{[info][request]}"] }
          useragent {
            source => "[info][http_user_agent]" target => "[info][useragent]"
            add_tag => [ "useragent" ]
          }
          geoip {
            source => "[info][remote_addr]" target => "geoip"
            add_tag => [ "geoip" ]
          }
        }

        # Jsonify elasticsearch messages
        if [unit] == "elasticsearch.service" {
          grok {
            # Match multiline elastisearch messages
            match => [ "message", "(?m)\[%{TIMESTAMP_ISO8601:timestamp}\]\s?\[%{LOGLEVEL:levelname}\]\s?\[%{DATA:[info][action]}\]\s?%{GREEDYDATA:message}" ]
            overwrite => [ "levelname", "message", "timestamp" ]
          }
          translate {
            field => "levelname"
            dictionary => [ ${levelname2priority} ]
            destination => "priority"
          }
        }
      }

      # Add cords to geoip to be usable by kibana
      if "geoip" in [tags] {
        mutate {
          add_field => [ "coords", "%{[geoip][longitude]}" ] 
          add_field => [ "tmplat", "%{[geoip][latitude]}" ]
          merge => [ "coords", "tmplat" ]
          convert => [ "coords", "float" ]
          remove => [ "tmplat" ]
        }
      }
    }
  '';
}
