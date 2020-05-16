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

    systems = [ "x86_64-linux" ];

    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

    nixpkgs' = nixpkgs;
    pkgsForSystem = system: nixpkgs.legacyPackages.${system};
    pkgsDefault = pkgsForSystem "x86_64-linux";

    nixosSystem' = {nixpkgs ? nixpkgs', ...}@args:
      nixpkgs.lib.nixosSystem ({
        modules = [ self.nixosModules.nix-profiles ] ++ (args.modules or []);
        inherit specialArgs;
      } // (filterAttrs (n: _: n != "nixpkgs" && n != "modules") args));

    buildIsoImage = configuration: (nixosSystem' {
      system = "x86_64-linux";
      modules = [ configuration ];
    }).config.system.build.isoImage;

    isRelease = (builtins.getEnv "release") != "";

    version = "2.0";

    getRev = input: "${toString input.lastModified}-${input.shortRev or "dirty"}";

    versionSufix = if isRelease then "" else "-${getRev self}";

    fullVersion = "${version}${versionSufix}";

    testingPython = system: import "${nixpkgs.outPath}/nixos/lib/testing-python.nix" {
      inherit system pkgs specialArgs;
    };

    buildVms = node: (testingPython.makeTest {
      nodes.node = {
        imports = [ self.nixos.module node ];
      };
      testScript = "";
    }).driver;

  in {
    inherit version fullVersion;

    lib = {
      nixosSystem = nixosSystem';
      nixos = import ./nixos;
      home-manager = import ./home-manager;
    };

    nixosModules.nix-profiles = import self.lib.nixos.module;
    homeManagerModules.nix-profiles = import self.lib.home-manager.module;

    packages = forAllSystems (system: filterAttrs (_: isDerivation) (import ./pkgs/all-packages.nix {
      pkgs = pkgsForSystem system;
    }));

    checks = forAllSystems (sys: {
      dev = (nixosSystem' {
        modules = [{
          imports = with self.lib.nixos; [
            system.minimal-part
            roles.dev
            profiles.user
            profiles.openssh
          ];

          home-manager.users.user = {config, ...}: {
            imports = with self.lib.home-manager; [
              # use i3 workspace
              workspaces.sway

              # set themes and colorschemes
              themes.materia
              themes.colorscheme.google-dark

              # set dev desktop role
              roles.desktop.dev
            ];
          };
        }];
        system = sys;
      }).config.system.build.toplevel;
    });

    tests.x86_64-linux-desktop = buildVms ({ pkgs, config, ... }: {
      imports = with self.lib.nixos; [
        roles.desktop
        profiles.user
      ];

      virtualisation.memorySize = 4096;
      virtualisation.qemu.options = mkAfter ["-vga qxl"];

      users.users.user.password = "foobar";

      home-manager.users.user = {config, ...}: {
        imports = with self.lib.home-manager; [
          # use i3 workspace
          workspaces.i3

          # set themes and colorschemes
          themes.materia
          themes.colorscheme.google-dark

          # set dev desktop role
          roles.desktop.dev
        ];

        xsession.windowManager.i3.config.modifier = "Mod1";
      };
    });

    # images to build
    images = rec {
      iso = buildIsoImage ./images/iso.nix;
      iso-dev = buildIsoImage ./images/iso-dev.nix;
      hyperv-image = (nixosSystem' {
        system = "x86_64-linux";
        modules = [ ./images/hyperv-image.nix ];
      }).config.system.build.hypervImage;
      hyperv-dev-image = (nixosSystem' {
        system = "x86_64-linux";
        modules = [ ./images/hyperv-dev-image.nix ];
      }).config.system.build.hypervImage;
      virtualbox-image = (nixosSystem' {
        system = "x86_64-linux";
        modules = [ ./images/virtualbox-image.nix ];
      }).config.system.build.virtualBoxOVA;
      google-compute-image = (nixosSystem' {
        system = "x86_64-linux";
        modules = [ ./images/google-compute-image.nix ];
      }).config.system.build.googleComputeImage;
      vagrant-qemu = (nixosSystem' {
        system = "x86_64-linux";
        modules = [ ./images/vagrant/qemu.nix ];
      }).config.system.build.toplevel;
      all = pkgsDefault.linkFarm "nix-profile-images-${fullVersion}" [{
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
