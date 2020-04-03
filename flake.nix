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
        modules = [ self.nixos.module ] ++ (args.modules or []);
        inherit specialArgs system;
      } // (filterAttrs (n: _: n != "nixpkgs" && n != "modules") args));

    buildIsoImage = configuration: (nixosSystem' {
      modules = [ configuration ];
    }).config.system.build.isoImage;

    isRelease = (builtins.getEnv "release") != "";

    version = "v2.0";

    getRev = input: "${builtins.substring 0 8 input.lastModified}_${input.shortRev or "dirty"}";

    versionSufix =
      if isRelease then "${getRev nixpkgs}-${getRev home-manager}"
      else "pre${getRev self}-${getRev nixpkgs}-${getRev home-manager}";

    fullVersion = "${version}-${versionSufix}";

  in {
    nixos = import ./nixos;
    home-manager = import ./home-manager;

    lib.nixosSystem = nixosSystem';

    pkgs = import ./pkgs/all-packages.nix { inherit pkgs; };

    checks.x86_64-linux.build = (nixosSystem' {
      modules = [{
        imports = with self.nixos; [
          self.nixos.system.iso
          roles.dev
          profiles.user
          profiles.openssh
        ];

        home-manager.users.user = {config, ...}: {
          imports = with self.home-manager; [
            # use i3 workspace
            workspaces.i3

            # set themes and colorschemes
            themes.materia
            themes.colorscheme.google-dark

            # set dev desktop role
            roles.desktop.dev

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
      virtualbox-image = (nixosSystem' {
        modules = [ ./images/virtualbox-image.nix ];
      }).config.system.build.virtualBoxOVA;
      google-compute-image = (nixosSystem' {
        modules = [ ./images/google-compute-image.nix ];
      }).config.system.build.googleComputeImage;
      all = pkgs.linkFarm "nix-profile-images-${fullVersion}" [{
        path = "${hyperv-image}/disk.vhdx";
        name = "nixos-hyperv-image-${fullVersion}.vhdx";
      } {
        path = "${hyperv-image}/disk.vhdx";
        name = "nixos-hyperv-dev-image-${fullVersion}.vhdx";
      } {
        path = "${virtualbox-image}/nixos.ova";
        name = "nixos-vbox-image-${fullVersion}.ova";
      }];
    };
  };
}
