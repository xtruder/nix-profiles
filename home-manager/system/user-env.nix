# system specific overrides for environments

{ lib, ... }:

with lib;

{
  config = {
    # redefine i3status for env
    programs.i3status.order = [
      (mkOrder 540 "volume master")
    ];

    # place default i3 bar on top
    xsession.windowManager.i3.defaultBarConfig.position = "top";

    # disable services which only require to run on parent
    services.screen-locker.enable = false;
    services.network-manager-applet.enable = false;
    services.pasystray.enable = false;
    services.udiskie.enable = false;
    services.redshift.enable = false;
  };
}
