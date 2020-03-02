{ config, ... }:

{
  imports = [
    ../apps/dunst.nix
    ../apps/i3.nix
    ../apps/i3status.nix
  ];

  config = {
    xsession.enable = true;
    services.screen-locker.enable = !config.attributes.hardware.isVM;
    programs.i3lock.enable = true;
    programs.rofi.enable = true;

    gtk.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
