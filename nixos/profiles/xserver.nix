# x11 role defines configuration for x11

{ config, lib, pkgs, ... }:

with lib;

{
  # enable xserver on workstations
  services.xserver = {
    # by default enable xserver
    enable = mkDefault true;
    autorun = true;

    # export configuration, so it's easier to debug
    exportConfiguration = true;

    layout = "us";

    desktopManager.xterm.enable = true;
    displayManager.gdm.enable = true;
  };

  # install a set of fonts i use
  fonts = {
    fonts = with pkgs; [
      terminus_font
      opensans-ttf
      roboto
      roboto-mono
      roboto-slab
      noto-fonts
      noto-fonts-emoji
      hasklig
      material-design-icons
      material-icons
      source-code-pro
      source-sans-pro
    ];
    fontconfig = {
      enable = mkForce true;
      defaultFonts = {
        monospace = ["Roboto Mono 13"];
        sansSerif = ["Roboto 13"];
        serif = ["Roboto Slab 13"];
      };
    };
    enableDefaultFonts = true;
  };

  # enable dconf support on all workstations for storage of configration
  programs.dconf.enable = mkDefault true;
}
