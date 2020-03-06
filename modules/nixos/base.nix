# base nixos module

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./home-manager.nix
    ./nixos-init.nix
    ../attributes.nix
  ];

  # enable nix-flakes support
  nix = {
    package = mkDefault pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.overlays = [
    (super: pkgs: import ../../pkgs/all-packages.nix { inherit pkgs; })
  ];
}
