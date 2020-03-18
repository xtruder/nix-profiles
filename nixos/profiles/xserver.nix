# x11 role defines configuration for x11

{ config, lib, ... }:

with lib;

{
  config = {
    # enable xserver on workstations
    services.xserver = {
      # by default enable xserver
      enable = mkDefault true;
      autorun = true;

      # export configuration, so it's easier to debug
      exportConfiguration = true;

      layout = "us";

      desktopManager.xterm.enable = true;
      displayManager.lightdm.enable = true;
    };
  };
}
