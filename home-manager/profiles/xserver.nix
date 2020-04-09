{ config, pkgs, ... }:

{
  config = {
    xsession.enable = true;

    home.sessionVariables = {
      GDK_BACKEND = "x11";
    };

    home.packages = with pkgs; [
      xsel
      xorg.xev
      xdotool
      glxinfo
    ];
  };
}
