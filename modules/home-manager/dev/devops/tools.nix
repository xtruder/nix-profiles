# admin devops profile defines tools for administrating databases

{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      # database
      sqlite
      mongodb
      mysql57
      #mysql-workbench
      postgresql
      redis
      etcdctl
      vault

      # storage
      s3fs
      minio-client
      gzrt # gzip recovery

      # remote
      rdesktop
      gtk-vnc
      openvpn

      # crypto
      mkpasswd
      pwgen
      apacheHttpd # for htpasswd
      xca
      cfssl

      # networking
      ncftp
      curl_unix_socket
      socat
      bmon
      tcptrack
      stunnel
      wireshark
    ];
  };
}
