# base nixos module

{ config, lib, ... }:

with lib;

let
  sources = import ../../nix/sources.nix;
  nixPath = mapAttrsToList (k: v: "${k}=${v}") (filterAttrs (n: _: n != "__functor") sources);

in {
  imports = [
    ./home-manager.nix
    ./nix-path.nix
    ../attributes.nix
  ];

  nix.nixPath = mkAfter nixPath;

  nixpkgs.overlays = [
    (super: pkgs: import ../../pkgs/all-packages.nix { inherit pkgs; })
  ];
}
