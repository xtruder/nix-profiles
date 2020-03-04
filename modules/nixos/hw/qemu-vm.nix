# qemu-vm define system role used for vms running in qemu

{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    boot.initrd = {
      # set kernel modules
      availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
      kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      postDeviceCommands = ''
        hwclock -s
      '';
    };

    security.rngd.enable = false;

    # enable spice-vdagent for spice support
    services.spice-vdagentd.enable = true;

    services.xserver = {
      # override video drivers to qxl and modesetting
      videoDrivers = mkOverride 50 [ "qxl" "modesetting" ];

      # run spice-vdagant with display manager
      displayManager.sessionCommands = ''
        ${pkgs.spice-vdagent}/bin/spice-vdagent
      '';
    };

    # use filesystem labeled with nixos as root and do auto resize
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    # bootloader is by default contained on /dev/vda
    boot.loader.grub.device = mkDefault "/dev/vda";

    attributes.hardware.isVM = true;
  };
}
