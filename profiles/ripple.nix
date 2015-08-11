{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.ripple = {
    enable = mkEnableOption "Whether to enable ripple profile.";
  };

  config = mkIf config.profiles.ripple.enable {
    services = {
      rippled = {
        enable = true;

        ledgerHistory = mkDefault 1296000;
        fetchDepth = "full";
        nodeSize = "large";

        databasePath = "/var/lib/rippled2";

        ports = {
          rpc = {
            port = 5005;
            admin = ["127.0.0.1"];
            protocol = ["http"];
          };

          peer = {
            port = 51235;
            ip = "0.0.0.0";
            protocol = ["peer"];
          };

          ws_public = {
            port = 5006;
            ip = "0.0.0.0";
            protocol = ["ws" "wss"];
          };
        };

        nodeDb = {
          type = "rocksdb";
          onlineDelete = config.services.rippled.ledgerHistory;
          advisoryDelete = true;
          compression = true;
          path = "/var/lib/rippled2";
          extraOpts = ''
            open_files=2000
            filter_bits=12
            cache_mb=256
            file_size_mb=8
            file_size_mult=2
          '';
        };

        statsd = mkIf config.profiles.metrics.enable {
          enable = true;
          address = "127.0.0.1:8125";
          prefix = "rippled_${config.networking.hostName}";
        };
      };

      rippleDataApi = {
        enable = true;
      };

      rippleRest = {
        enable = true;
        debug = true;
        host = "0.0.0.0";
        rippleds = [
          "ws://localhost:5006"
          "wss://s1.ripple.com:443"
        ];
      };

      #cron = {
        #enable = mkDefault true;
        #systemCronJobs = [
          #"@hourly root systemctl restart ripple-data-importer"
        #];
      #};
    };

    systemd.services.ripple-data-api.serviceConfig.PartOf = ["rippled.service"];

    attributes.services.rippled = let
      checkRipple = cmd: match: check:
        "${pkgs.rippled}/bin/rippled --conf ${config.services.rippled.config} ${cmd} | ${pkgs.jq}/bin/jq '${match}' | ${check}";
    in {
      port = 5990;
      host = "ripple.gatehub.net";
      checks = {
        active = {
          script = "/var/run/current-system/sw/bin/systemctl is-active rippled";
          interval = "10s";
        };
        server_info = {
          script = "${pkgs.rippled}/bin/rippled --conf ${config.services.rippled.config} server_info";
          interval = "30s";
        };
        no_skipped_ledgers = {
          script = checkRipple "server_info" ".result.info.complete_ledgers" "grep -v -E ','";
          interval = "30s";
        };
        server_state = {
          script = checkRipple "server_info" ".result.info.server_state" "grep -E 'full|syncing'";
          interval = "30s";
        };
      };
    };

    attributes.services.ripple-data-api = {
      port = 5993;
      checks = {
        active_api = {
          script = "/var/run/current-system/sw/bin/systemctl is-active ripple-data-api";
          interval = "10s";
        };
        active_importer = {
          script = "/var/run/current-system/sw/bin/systemctl is-active ripple-data-importer";
          interval = "10s";
        };
      };
    };

    attributes.services.ripple-rest = {
      port = 5990;
      checks = {
        active = {
          script = "/var/run/current-system/sw/bin/systemctl is-active ripple-rest";
          interval = "10s";
        };
        ripple_rest_success = {
          script = "/run/current-system/sw/bin/curl localhost:5990/v1/server/connected | ${pkgs.jq}/bin/jq '.success' | grep true";
          interval = "10s";
        };
        ripple_rest_connected = {
          script = "/run/current-system/sw/bin/curl localhost:5990/v1/server/connected | ${pkgs.jq}/bin/jq '.connected' | grep true";
          interval = "10s";
        };
      };

    };

    profiles.nginx.snippets.ripple = ''
      location / {
        include ${config.profiles.nginx.snippets.ws};
        proxy_pass http://rippled;
      }

      location /api {
        include ${config.profiles.nginx.snippets.proxy};
        proxy_pass http://ripple-data-api;
      }

      location /v1 {
        include ${config.profiles.nginx.snippets.proxy};
        proxy_pass http://ripple-rest;
      }
    '';
  };
}
