# base nixos module

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./home-manager.nix
    ./nixos-init.nix
    ./profiles/nix.nix
    ../attributes.nix
  ];

  nixpkgs.overlays = [
    (super: pkgs: import ../../pkgs/all-packages.nix { inherit pkgs; })
  ];
}
