# system specific overrides for environments

{ config, ... }:

{
  config = {
    # disable i3status blocks
    programs.i3status.order = mkForce [];

    # place default i3 bar on top
    xsession.windowManager.i3.defaultBar.position = "top";

    # disable screen locker in environments
    services.screen-locker.enable = false;
  };
}
