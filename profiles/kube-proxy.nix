# kubernetes reverse proxy based on etcd, confd and nginx

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.kubernetes.reverseProxy;

  nginxTpl = ''
    {{range $spec := getvs "/registry/services/specs/*/*"}}
    {{$data := json $spec}}
    {{ if $data.metadata.annotations.kubernetesReverseproxy }}
    {{$p := json $data.metadata.annotations.kubernetesReverseproxy }}
    {{range $proxy := $p.hosts}}
    {{if $proxy.host }}
    server {

        {{if $proxy.port }} listen {{$proxy.port}}; {{end}}
        server_name {{$proxy.host}};

        {{if $proxy.ssl   }}
        ssl_certificate           /etc/ssl/localcerts/{{$proxy.sslCrt}};
        ssl_certificate_key       /etc/ssl/localcerts/{{$proxy.sslKey}};

        ssl on;
        ssl_session_cache  builtin:1000  shared:SSL:10m;
        ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
        ssl_prefer_server_ciphers on;
        {{ end }}

        {{if $proxy.path }}
        {{range $path := $proxy.path}}
        location {{$path}}/ {

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;

            {{if $proxy.ssl   }}
            proxy_redirect http:// https://;
            {{ else }}
            proxy_redirect off;
            {{ end }}

            {{if $proxy.webSocket   }}
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            {{ end }}

            proxy_pass http://{{$data.portalIP}}:{{$data.port}};
        }
        {{ end }}

        {{ if $proxy.defaultPath}}
        location / {
            rewrite ^/$ {{$proxy.defaultPath}}/ permanent;
        }
        {{ end }}
        {{ else }}
        location / {

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;

            {{if $proxy.ssl   }}
            proxy_redirect http:// https://;
            {{ else }}
            proxy_redirect off;
            {{ end }}

            {{if $proxy.webSocket   }}
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            {{ end }}

            proxy_pass http://{{$data.spec.portalIP}}:{{$proxy.port}};
        }
        {{ end }}

    }
    {{ end }}
    {{ end }}
    {{ end }}
    {{ end }}
  '';

  confdTpl = ''
    [template]

    src = "nginx.tmpl"
    dest = "${cfg.configPath}"

    keys = [ "/registry/services/specs/" ]
    owner = "nginx"
    mode = "0644"

    #check_cmd = "nginx -t -c {{.src}}"
    reload_cmd = "systemctl reload nginx"
  '';

in {
  options.services.kubernetes.reverseProxy = {
    enable = mkEnableOption "Whether to enable kubernetes reverse proxy.";

    configPath = mkOption {
      description = "Nginx path for reverse proxy config.";
      default = "/var/lib/kubernetes/nginx.conf";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    services.confd.enable = mkDefault true;

    environment.etc = {
      "confd/conf.d/kubernetes.toml".text = confdTpl;
      "confd/templates/nginx.tmpl".text = nginxTpl;
    };

    systemd.services.confd.serviceConfig.Restart = "on-failure";
    systemd.services.confd.preStart = ''
      ${pkgs.goPackages.confd}/bin/confd -onetime -config-file /etc/confd/conf.d/kubernetes.toml
    '';
  };
}
