{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.desktop.enable = mkEnableOption "desktop role";

  config = mkIf config.roles.desktop.enable {
    roles.workstation.enable = true;
    roles.system.enable = true;

    # enable libvirt profile by default on all work machines
    profiles.libvirt.enable = mkDefault true;

    # enable suspend
    powerManagement.enable = mkDefault true;

    # multimedia support
    hardware.opengl.driSupport32Bit = mkDefault true;

    # eth0 is by default external interface
    networking.nat.externalInterface = mkDefault "eth0";
  };
}
