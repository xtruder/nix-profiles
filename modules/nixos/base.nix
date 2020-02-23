# base nixos module

{ config, ... }:

{
  imports = [ ./home-manager.nix ../attributes.nix ];

  nixpkgs.overlays = [
    (super: pkgs: import ../../pkgs/all-packages.nix { inherit pkgs; })
  ];
}
