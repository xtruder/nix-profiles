{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.nginx;

in {
  options = {
    profiles.nginx = {
      enable = mkEnableOption "Whether to enable nginx profile.";

      config = mkOption {
        description = "Nginx config.";
        default = "";
        type = types.lines;
      };

      proxy = {
        enable = mkOption {
          description = "Whether to enable proxy for defined services.";
          default = false;
          type = types.bool;
        };

        domain = mkOption {
          description = "Nginx proxy domain suffix.";
          default = config.attributes.domain;
          type = types.str;
        };
      };

      snippets = mkOption {
        description = "Nginx config snippets.";
        apply = snippets:
          mapAttrs (n: s: pkgs.writeText "nginx-${n}.config" s) snippets;
        type = types.attrs;
      };

      corsAllowOrigin = mkOption {
        default = "*";
        description = "Allowed origin for cors.";
        type = types.str;
      };

      corsAllowHeaders = mkOption {
        default = [];
        description = "List of allowed headers for cors.";
        type = types.listOf types.str;
      };
    };
  };

  config = {
    services.nginx = {
      enable = true;
      config = ''
        events {
          worker_connections 1024;
        }

        http {
          include ${config.profiles.nginx.snippets.http};

          ${concatStrings (mapAttrsToList (n: svc: ''
          server {
            listen ${config.attributes.privateIPv4}:80;
            server_name ${svc.name}.service.${cfg.proxy.domain};

            location / {
              include ${config.profiles.nginx.snippets.proxy};
              proxy_pass http://${svc.host}:${toString svc.port};
            }
          }
          '') (filterAttrs (n: v: v.proxy.enable) config.attributes.services))}

          ${cfg.config}
        }
      '';
    };

    profiles.nginx.snippets = {
      syslog = ''
        error_log syslog:server=unix:/var/log;
        access_log syslog:server=unix:/var/log;
      '';

      http = ''
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;

        include ${pkgs.nginx}/conf/mime.types;
        default_type application/octet-stream;

        gzip on;
        gzip_disable "msie6";
      '';

      proxy = ''
        proxy_set_header        Host $host;
        proxy_set_header        X-Forwarded-Host $host;
        proxy_set_header        X-Forwarded-Server $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;

        client_max_body_size    10m;
        client_body_buffer_size 128k;
        proxy_connect_timeout   60s;
        proxy_send_timeout      90s;
        proxy_read_timeout      90s;
        proxy_buffering         off;
        proxy_temp_file_write_size 64k;
      '';

      ws = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';

      logjson = ''
        log_format logjson '{ "@timestamp": "$time_iso8601", '
                           '"@fields": { '
                           '"remote_addr": "$remote_addr", '
                           '"remote_user": "$remote_user", '
                           '"body_bytes_sent": "$body_bytes_sent", '
                           '"request_time": "$request_time", '
                           '"status": "$status", '
                           '"request": "$request", '
                           '"request_method": "$request_method", '
                           '"http_referrer": "$http_referer", '
                           '"http_user_agent": "$http_user_agent" } }';
      '';

      status = ''
        location /nginx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }
      '';

      cors =
        let
          corsHeaders = ''
            more_set_headers 'Access-Control-Allow-Origin: ${cfg.corsAllowOrigin}';
            more_set_headers 'Access-Control-Allow-Credentials: true';
            more_set_headers 'Access-Control-Allow-Methods: GET, POST, PUT, OPTIONS';
            more_set_headers 'Access-Control-Allow-Headers: DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,${concatStringsSep "," cfg.corsAllowHeaders}';
          '';
        in ''
            if ($request_method = 'OPTIONS') {
                ${corsHeaders}

                #
                # Tell client that this pre-flight info is valid for 20 days
                #

                more_set_headers 'Access-Control-Max-Age: 1728000';
                more_set_headers 'Content-Type: text/plain charset=UTF-8';
                more_set_headers 'Content-Length: 0';

                return 204;
            }

            if ($request_method = 'GET') {
                ${corsHeaders}
            }

            if ($request_method = 'POST') {
                ${corsHeaders}
            }

            if ($request_method = 'PUT') {
                ${corsHeaders}
            }
        '';

        extraServers = mkDefault "";
    };
  };
}
