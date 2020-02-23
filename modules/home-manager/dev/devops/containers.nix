# devops tools for working with containers

{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      docker
      docker-compose
      podman
      skopeo
      proot
      nix-prefetch-docker
    ];
  };
}
