{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.desktop.enable = mkEnableOption "desktop role";

  config = mkIf config.roles.desktop.enable {
    roles.work.enable = true;
    roles.system.enable = true;

    profiles.x11.enable = mkDefault true;
    profiles.i3.enable = mkDefault true;

    # firmware config
    hardware.enableAllFirmware = mkDefault true;

    # multimedia support
    hardware.opengl.driSupport32Bit = mkDefault true;

    # enable suspend
    powerManagement.enable = mkDefault true;
  };
}
