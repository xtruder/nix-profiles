{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.network-manager;
in {
  options.profiles.network-manager.enable = mkEnableOption "networkmanager profile";

  config = mkIf cfg.enable {
    services.network-manager-applet.enable = true;

    nixos.passthru = {
      networking.networkmanager.enable = true;
    };
  };
}
