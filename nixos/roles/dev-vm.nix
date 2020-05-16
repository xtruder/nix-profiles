{ pkgs, lib, ... }:

with lib;

{
  imports = [
    ./base.nix

    ../profiles/xserver.nix
    ../profiles/pulseaudio.nix
    ../profiles/docker.nix
    ../profiles/android.nix
    ../profiles/nix-dev.nix
  ];

  # enable tun and fuse on work machines
  boot.kernelModules = [ "tun" "fuse" ];
}
