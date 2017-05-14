{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.qemu;
in {
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    <nixpkgs/nixos/modules/virtualisation/grow-partition.nix>
  ];

  options = {
    qemu = {
      baseImageSize = mkOption {
        type = types.int;
        default = 10 * 1024;
        description = ''
          The size of the qemu base image in MiB.
        '';
      };

      format = mkOption {
        type = types.enum ["raw" "qcow2"];
        default = "qcow2";
        description = "Qemu image format";
      };
    };
  };

  config = {
    system.build.qemu = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      name = "nixos-qemu-${config.system.nixosLabel}-${pkgs.stdenv.system}";

      inherit pkgs lib config;
      partitioned = true;
			diskSize = cfg.baseImageSize;
			format = cfg.format;
    };

    services.openssh.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwxJJWJGkdGWoUpCKUN9iHmJkP4LOTXhOJPbNfVBbAnWTpS4Ee8kGuFOREnJD6mmn1oe2GWuaZm7FvYTV8ESdyAia63/PF8XOMsmPRk9BI8yHgV1I0+ADeMoikD/uXIYrwdi8dWU+O2DXoeY6otsTEsRVCK+j/DGf1Cjzd7B4bz/j0emCexQQbU3o7lDRZeq1UiJEVPDomQNvNCq4NBCWxoRIxBIBslKFqKsGXidU6ExDf6Rwiwo+WRFcJ1tFpNutJUjRlTLLjCX93dySrn43+0lUcrTu0EiWlkKqVGZ0kwjCCIkX9+KkhOWiUc3/Hxhxul9KluYtbx9dWwhnF8MKD deploy@xtruder"
    ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
    };

    boot.loader.grub.device = "/dev/vda";
  };
}
