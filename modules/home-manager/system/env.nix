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

    # disable screen locker in environments
    services.screen-locker.enable = false;
  };
}
