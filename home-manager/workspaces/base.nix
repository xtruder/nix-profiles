# base configuration for workspaces

{ config, pkgs, ... }:

{
  config = {
    xsession.enable = true;

    gtk.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk";
    };

    home.packages = with pkgs; [
      xsel
      xorg.xev
      xdotool
      glxinfo
    ];
  };
}
