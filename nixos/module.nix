# base nixos module

{ config, lib, pkgs, ... }:

with lib;

{
  imports = import ./modules/module-list.nix;

  nixpkgs.overlays = [
    (super: pkgs: import ../pkgs/all-packages.nix { inherit pkgs; })
  ];
}
