{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.networkmanager.enable = mkEnableOption "network manager with dnsmasq";

  config = mkIf config.profiles.networkmanager.enable {
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ''; 

    networking.networkmanager = {
      enable = mkDefault true;
      insertNameservers = ["127.0.0.1"];
    };

    services.dnsmasq.enable = mkDefault true;
  };
}
