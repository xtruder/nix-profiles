{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.qemu;
in {
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
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
    boot.growPartition = true;

    system.build.qemu = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      name = "nixos-qemu-${config.system.nixos.label}-${pkgs.stdenv.system}";

      inherit pkgs lib config;
	    diskSize = cfg.baseImageSize;
	    format = cfg.format;
    };

    services.openssh.enable = true;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.loader.grub.device = "/dev/vda";
  };
}
