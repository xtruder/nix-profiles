{ config, pkgs, ... }:

{
  config = {
    # enable wayland backends for different backend platforms
    home.sessionVariables = {
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };

    programs.chromium.package = pkgs.chromiumOzone.override {
      commandLineArgs = "--ozone-platform=wayland";
    };

    programs.firefox.package = pkgs.firefox-wayland;
  };
}
