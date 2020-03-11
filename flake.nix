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

    checks.x86_64-linux.build = (nixosSystem' {
      modules = [{
        imports = with self.nixosModules; [
          self.nixosModules.system.iso
          environments.dev
          profiles.user
          profiles.openssh
        ];

        home-manager.users.user = {config, ...}: {
          imports = with self.homeManagerModules; [
            # use i3 workspace
            workspaces.i3

            # set themes and colorschemes
            themes.materia
            themes.colorscheme.google-dark

            # set dev desktop environment
            environments.desktop.dev

            # enable development profiles
            dev.devops.all
            dev.android
            dev.go
            dev.node
            #dev.elm
            #dev.haskell
            dev.python
            dev.ruby
            dev.nix
          ];
        };
      }];
    }).config.system.build.toplevel;

    # images to build
    images = rec {
      iso = buildIsoImage ./images/iso.nix;
      iso-dev = buildIsoImage ./images/iso-dev.nix;
      hyperv-image = (nixosSystem' {
        modules = [ ./images/hyperv-image.nix ];
      }).config.system.build.hypervImage;
      hyperv-dev-image = (nixosSystem' {
        modules = [ ./images/hyperv-dev-image.nix ];
      }).config.system.build.hypervImage;
      all = pkgs.linkFarm "nix-profile-images-${fullVersion}" [{
        path = "${hyperv-image}/disk.vhdx";
        name = "nixos-hyperv-image-${fullVersion}.vhdx";
      } {
        path = "${hyperv-image}/disk.vhdx";
        name = "nixos-hyperv-dev-image-${fullVersion}.vhdx";
      }];
    };
  };
}
