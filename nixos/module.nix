# base nixos module

{ config, lib, pkgs, nur, ... }:

with lib;

{
  imports = import ./modules/module-list.nix;

  nixpkgs.overlays = [
    (super: pkgs: import ../pkgs/all-packages.nix { inherit pkgs; })
    nur.overlay
  ];
}
