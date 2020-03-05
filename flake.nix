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

    nixosSystem' = args: nixosSystem ({ inherit specialArgs system; } // args);

    buildIsoImage = configuration: (nixosSystem' {
      modules = [ configuration ];
    }).config.system.build.isoImage;

    modules = import ./modules;

  in {
    inherit nixosSystem';

    # exporter nixos modules
    nixosModules = modules.nixos;

    # exported home manager modules
    homeManagerModules = modules.home-manager;

    # images to build
    images = {
      iso = buildIsoImage ./images/iso.nix;
      iso-dev = buildIsoImage ./images/iso-dev.nix;
      hyperv-image = (nixosSystem' {
        modules = [ ./images/hyperv-image.nix ];
      }).config.system.build.hypervImage;
    };
  };
}
