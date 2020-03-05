# base nixos module

{ config, lib, ... }:

with lib;

{
  imports = [
    ./home-manager.nix
    ./nixos-init.nix
    ../attributes.nix
  ];

  nixpkgs.overlays = [
    (super: pkgs: import ../../pkgs/all-packages.nix { inherit pkgs; })
  ];
}
