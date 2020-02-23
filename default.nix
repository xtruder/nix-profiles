{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, lib ? import ./lib { inherit pkgs; inherit (pkgs) lib; }}:

with lib;

let
  extraPkgs = import ./pkgs/all-packages.nix { inherit pkgs; };

  evalConfig = import (loadPath <np-nixpkgs/nixos/lib/eval-config.nix> "${sources.nixpkgs}/nixos/lib/eval-config.nix");

  modules = import ./modules;

  evalNixOSConfig = { ... }@args: evalConfig (args // {
    inherit lib;
    modules = (args.modules or []) ++ [modules.nixos.base];
    specialArgs = args.specialArgs or {} // {
      # pass sources so they can be imported in modules and overriden
      inherit sources nix-profiles;
    };
  });

  buildIsoImage = configuration: _: (evalNixOSConfig {
    modules = [ configuration ];
  }).config.system.build.isoImage;

  nix-profiles =  {
    inherit evalNixOSConfig modules;

    pkgs = extraPkgs;

    images = {
      iso = buildIsoImage ./images/iso.nix {};
      iso-dev = buildIsoImage ./images/iso-dev.nix {};
    };
  };

in nix-profiles
