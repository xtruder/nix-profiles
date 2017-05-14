{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.roles.qemu;
in {
  options.roles.qemu = {
    enable = mkEnableOption "qemu profile";
  };

  config = mkIf cfg.enable {
    boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
    boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

    boot.initrd.postDeviceCommands =
      ''
        # Set the system time from the hardware clock to work around a
        # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
        # to the *boot time* of the host).
        hwclock -s
      '';

    security.rngd.enable = false;

    services.spice-vdagentd.enable = true;
    services.xserver.videoDrivers = mkOverride 50 [ "qxl" "modesetting" ];
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.spice-vdagent}/bin/spice-vdagent
    '';

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
    };

    boot.loader.grub.device = "/dev/vda";
  };
}
