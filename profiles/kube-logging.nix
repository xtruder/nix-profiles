# kubernetes logging based on etcd, confd and fluentd

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kubernetes.logging;

  fluentdTpl = ''
    {{range $spec := getvs "/registry/pods/*/*"}}
    {{$data := json $spec}}
    {{range $status := $data.status.containerStatuses}}
    {{if $status.containerID }}
    {{ $id := index (split ($status.containerID) "://") 1 }}
    <source>
      type tail
      path /var/lib/docker/containers/{{ $id }}/{{ $id }}-json.log
      pos_file /var/log/fluentd-docker.pos
      time_format %Y-%m-%dT%H:%M:%S
      tag docker.{{ $id }}
      format json
    </source>
    <match docker.{{ $id }}>
      type record_reformer
      tag kubernetes.{{ $data.metadata.name }}
      <record>
        container_id {{ $id }}
        name {{ $data.metadata.name }}
        namespace {{ $data.metadata.namespace }}
      </record>
    </match>
    {{end}}
    {{end}}
    {{end}}
  '';

  confdTpl = ''
    [template]

    src = "fluentd.tmpl"
    dest = "/var/lib/kubernetes/fluentd.conf"
    keys = [ "/registry/pods/" ]

    owner = "fluentd"
    mode = "0644"

    #check_cmd = "nginx -t -c {{.src}}"
    reload_cmd = "systemctl reload fluentd"
  '';


in {
  options.services.kubernetes.logging = {
    enable = mkEnableOption "Whether to enable logging for kubernetes.";
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "confd/conf.d/fluentd.toml".text = confdTpl;
      "confd/templates/fluentd.tmpl".text = fluentdTpl;
    };

    systemd.services.confd.preStart = ''
      ${pkgs.goPackages.confd}/bin/confd -onetime -config-file /etc/confd/conf.d/fluentd.toml
    '';

    services.fluentd = {
      enable = true;
      config = ''
        @include /var/lib/kubernetes/fluentd.conf

        <match kubernetes.**>
          type elasticsearch
          log_level info
          include_tag_key true
          host localhost
          port 9200
          logstash_format true
          flush_interval 5s
          # Never wait longer than 5 minutes between retries.
          max_retry_wait 300
          # Disable the limit on the number of retries (retry forever).
          disable_retry_limit
          index_name kubernetes
        </match>
      '';
    };
  };
}
