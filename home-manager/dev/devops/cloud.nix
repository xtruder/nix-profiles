{ config, pkgs, ... }:

{
  imports = [ ../base.nix ];

  config = {
    programs.vscode.extensions = [
      pkgs.my-vscode-extensions.terraform
    ];

    home.packages = with pkgs; [
      # cloud tools
      awscli
      ec2_ami_tools
      ec2_api_tools
      google-cloud-sdk
      #azure-cli

      # provisioning
      ansible
      terraform
    ];
  };
}
