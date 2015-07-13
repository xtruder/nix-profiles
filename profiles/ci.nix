{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.ci;

in {
  options.profiles.ci = {
    enable = mkEnableOption "Whether to enable jenkins profile.";
  };

  config = mkIf cfg.enable {
    services = {
      jenkins.enable = true;
      jenkins.port = 8033;
      jenkinsSlave.enable = true;
      #sinopia.enable = mkDefault true;
    };

    users.extraUsers.jenkins.extraGroups = mkIf config.virtualisation.docker.enable [ "users" "docker" ];
    systemd.services.jenkins.serviceConfig.TimeoutStartSec = "6min";
    systemd.services.jenkins.environment.GIT_SSL_CAINFO =
      ''/etc/ssl/certs/ca-bundle.crt'';
    systemd.services.jenkins.path = [ pkgs.docker ];

    profiles.nginx.upstreams = {
      jenkins = { servers = [ "127.0.0.1:8033"]; };
      #sinopia = { servers = [ "127.0.0.1:${toString config.services.sinopia.port}"]; };
    };

    profiles.nginx.snippets.ci = ''
      location / {
        proxy_pass http://jenkins;
        include ${config.profiles.nginx.snippets.proxy};
      }
    '';

    #profiles.nginx.snippets.sinopia = ''
      #location / {
        #proxy_pass http://sinopia;
        #include ${config.profiles.nginx.snippets.proxy};
      #}
    #'';
  };
}
