{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, extraConfig ? {} }:

with lib;

let
  extraPkgs = import ./pkgs/all-packages.nix { inherit pkgs; };

  evalConfig = import <nixpkgs/nixos/lib/eval-config.nix>;

  modules = import ./modules;

  buildIsoImage = configuration: _: (evalConfig {
    modules = [ configuration extraConfig ];
  }).config.system.build.isoImage;

  nix-profiles =  {
    inherit modules;

    pkgs = extraPkgs;

    images = {
      iso = buildIsoImage ./images/iso.nix {};
      iso-dev = buildIsoImage ./images/iso-dev.nix {};
      hyperv-image = (evalConfig {
        modules = [ ./images/hyperv-image.nix extraConfig ];
      }).config.system.build.hypervImage;
    };
  };

in nix-profiles
