{ config, pkgs, ... }:

{
  config = {
    # enable wayland backends for different backend platforms
    home.sessionVariables = {
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };

    programs.firefox.package = pkgs.firefox-wayland;

    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
