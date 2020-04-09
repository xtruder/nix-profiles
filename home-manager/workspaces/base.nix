# base configuration for workspaces

{ config, pkgs, ... }:

{
  config = {
    xdg.mimeApps.enable = true;

    gtk.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
