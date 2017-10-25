{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.ops;
in {
  options.roles.dev.ops.enable = mkEnableOption "OPS development";

  config = mkIf cfg.enable {
    profiles.vbox.enable = mkDefault true;

    environment.systemPackages = with pkgs; [
      packer
      vagrant
      kubernetes
      kubernetes-helm
      awscli
      ec2_ami_tools
      ec2_api_tools
      google-cloud-sdk
      terraform
      kops
      kops.out
      azure-cli
      nixops
      ansible
      telepresence
      remarshal
    ];
  };
}
