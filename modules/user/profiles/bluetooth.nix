{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.bluetooth;
in {
  options.profiles.bluetooth = {
    enable = mkEnableOption "bluetooth profile";
  };

  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;

    nixos.passthru = {
      services.dbus.packages = [ pkgs.blueman ];
    };
  };
}
