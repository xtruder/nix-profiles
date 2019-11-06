{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.work.enable = mkEnableOption "work role";

  config = mkIf config.roles.work.enable {
    home-manager.users.admin.roles.work.enable = true;

    services.earlyoom.enable = mkDefault true;

    profiles.printingAndScanning.enable = mkDefault true;

    users.extraGroups.plugdev = {};
    users.groups.plugdev.members = ["${config.users.users.admin.name}"];    

    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="8016", MODE="0660", GROUP="bcvault"
    '';

    programs.sysdig.enable = true;
  };
}
