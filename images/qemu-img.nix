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

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDonhV1A74Eb99InQtRbBEEiX3SAxUifWKuQLefQeWGkjSeYJ+4MRSfFuu4/VnVaAH8B2CgxULKzWLZYfALcekCD75XBzGTWYB5tD/irdvh9UUtiH0XUvVr+z9Q1E6scW5xC9cyeHcqc00/TsvFej4OR/zTBkYh+DRsP5hFgthm4d4r+TuF7ohltgmIoN9TMcM7UOyyxxdgRw9zorgB/biClnaLbKWzT+lrg5hvGu7SxQS7LFisRy4GiOn4gaoTDvC3bVBqPXwbAykjGq9TVgyEUXzjYce8clFy2imiMPi2mCgkp2ahGDGHztXsortiJL8PVavL/lh/nd0yk17ty2Y/ offlinehacker@xtruder"
    ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.loader.grub.device = "/dev/vda";
  };
}
