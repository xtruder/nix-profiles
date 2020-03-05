{
  edition = 201909;

  description = "A reusable collection of nix-profiles used by X-Truder Networks";

  inputs = {
    nixpkgs.uri = "github:xtruder/nixpkgs/xtruder-nixos-unstable";
    home-manager.uri = "github:xtruder/home-manager/nix-profiles-2-0";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosModules.nix-profiles = import ./modules;

    images.iso-dev = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./images/iso-dev.nix ];
      specialArgs.nix-profiles = self.nixosModules.nix-profiles;
    };
  };
}
