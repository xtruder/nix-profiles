{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.nginx;

in {
  options = {
    profiles.nginx = {
      snippets = mkOption {
        description = "Nginx config snippets.";
        apply = snippets:
          mapAttrs (n: s: pkgs.writeText "nginx-${n}.config" s) snippets;
        type = types.attrs;
      };

      upstreams = mkOption {
        description = "Nginx upstreams.";
        apply = u: pkgs.writeText "nginx-upstreams.config" (
          concatStringsSep "\n" (mapAttrsToList (name: val: ''
            upstream ${name} {
              ${concatMapStringsSep "\n" (s: "server ${s};") val.servers}
            }
          '') u)
        );
        type = types.attrsOf types.optionSet;
        options = [{
          servers = mkOption {
            description = "List of servers.";
            apply = unique;
            type = types.listOf types.str;
          };
        }];
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
    profiles.nginx.snippets = {
      syslog = ''
        syslog daemon nginx;
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

    services.nginx.package = pkgs.nginx.override { syslog = true; };
  };
}
