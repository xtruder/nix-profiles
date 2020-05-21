{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ../base.nix ];

  config = {
    programs.vscode.extensions = [
      pkgs.my-vscode-extensions.vscode-kubernetes-tools
    ];

    home.packages = with pkgs; [
      kubectl
      kubernetes-helm
      kops
      kops.out
      telepresence
      kail
      helmfile
      kubicorn
      kubectx
      kind
      minikube
      fluxctl
    ];
  };
}
