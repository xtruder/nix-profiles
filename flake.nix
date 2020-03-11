{
  edition = 201909;

  description = "A reusable collection of nix-profiles used by X-Truder Networks";

  inputs = {
    nixpkgs.uri = "github:xtruder/nixpkgs/xtruder-nixos-unstable";
    home-manager.uri = "github:xtruder/home-manager/nix-profiles-2-0";
  };

  outputs = { self, nixpkgs, home-manager }:
    with nixpkgs.lib;
  let
    specialArgs = {
      nix-profiles = self;
      home-manager = home-manager;
    };

    system = "x86_64-linux";
    nixpkgs' = nixpkgs;
    pkgs = nixpkgs.legacyPackages.${system};

    nixosSystem' = {nixpkgs ? nixpkgs', ...}@args:
      nixpkgs.lib.nixosSystem ({
        inherit specialArgs system;
      } // (filterAttrs (n: _: n != "nixpkgs") args));

    buildIsoImage = configuration: (nixosSystem' {
      modules = [ configuration ];
    }).config.system.build.isoImage;

    modules = import ./modules;

    isRelease = (builtins.getEnv "release") != "";

    version = "v2.0";

    getRev = input: "${builtins.substring 0 8 input.lastModified}_${input.shortRev or "dirty"}";

    versionSufix =
      if isRelease then "${getRev nixpkgs}-${getRev home-manager}"
      else "pre${getRev self}-${getRev nixpkgs}-${getRev home-manager}";

    fullVersion = "${version}-${versionSufix}";

  in {
    lib.nixosSystem = nixosSystem';

    # exporter nixos modules
    nixosModules = modules.nixos;

    # exported home manager modules
    homeManagerModules = modules.home-manager;

    # images to build
    images = rec {
      iso = buildIsoImage ./images/iso.nix;
      iso-dev = buildIsoImage ./images/iso-dev.nix;
      hyperv-image = (nixosSystem' {
        modules = [ ./images/hyperv-image.nix ];
      }).config.system.build.hypervImage;
      all = pkgs.linkFarm "nix-profile-images-${fullVersion}" [{
        path = "${hyperv-image}/disk.vhdx";
        name = "nixos-hyperv-image-${fullVersion}.vhdx";
      }];
    };
  };
}
