# base configuration for workspaces

{ config, ... }:

{
  config = {
    xsession.enable = true;

    gtk.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
