{ config, ... }:

{
  config = {
    xsession.enable = true;

    services.screen-locker.enable = !config.attributes.hardware.isVM;

    gtk.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
