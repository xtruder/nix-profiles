{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.admin.enable = mkEnableOption "admin role";

  config = mkIf config.roles.admin.enable {
    profiles.wireshark.enable = true;

    environment.systemPackages = with pkgs; [
      # crypto
      mkpasswd
      pwgen
      apacheHttpd # for htpasswd
      xca

      # fs
      s3fs
      gzrt # gzip recovery

      # networking
      ncftp
      curl_unix_socket
      socat
      bmon
      tcptrack
      stunnel

      # cloud
      kubernetes
      awscli
      google-cloud-sdk
      virtmanager

      # database
      sqlite
      mongodb
      mysql55
      mysql-workbench
      postgresql
      redis
      etcdctl

      # remote
      rdesktop
      gtkvnc

      wireshark
    ];
  };
}
