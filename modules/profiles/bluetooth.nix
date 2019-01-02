{ config, lib, pkgs, ... }:

with lib;

{ 
  options.profiles.bluetooth.enable = mkEnableOption "bluetooth";

  config = mkIf config.profiles.bluetooth.enable {
    hardware.bluetooth.enable = true;

    services.dbus.packages = [ pkgs.blueman ];

    # run these commands as session commands if running with gui
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.blueman}/bin/blueman-applet &
    '';
  };
}
