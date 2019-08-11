{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.ops;
in {
  options.roles.dev.ops.enable = mkEnableOption "DevOps development role";

  config = mkIf cfg.enable {
    programs.vscode.extensions = [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "terraform";
          publisher = "mauve";
          version = "1.2.0";
          sha256 = "04jk9ydzz8rwv8y3bphl2v5h9a73qjgs2bs22m0glh4wsq8d7h55";
        };
      })
    ];

    home.packages = with pkgs; [
      # cloud tools
      awscli
      ec2_ami_tools
      ec2_api_tools
      google-cloud-sdk
      azure-cli

      # provisioning
      nixops
      ansible
      terraform

      # virt
      libvirt
      virtmanager
      vagrant
      packer

      # kubernetes
      kubectl
      kubernetes-helm
      kops
      kops.out
      telepresence
      kail
      helmfile
      kubicorn
      kubectx
      kind.bin
      minikube.bin

      # container tools
      skopeo
      proot
      #nix-prefetch-docker

      # crypto
      mkpasswd
      pwgen
      apacheHttpd # for htpasswd
      xca
      cfssl

      # storage
      s3fs
      minio-client
      gzrt # gzip recovery

      # networking
      ncftp
      curl_unix_socket
      socat
      bmon
      tcptrack
      stunnel
      wireshark

      # database
      sqlite
      mongodb
      mysql57
      #mysql-workbench
      postgresql
      redis
      etcdctl
      vault

      # kafka
      confluent-platform

      # remote
      rdesktop
      gtk-vnc
      openvpn

      winusb
    ];
  };
}
