{ config, ... }:

{
  config = {
    # enable bluetooth support on all workstations
    hardware.bluetooth.enable = true;

    # enable blueman dbus service
    #services.blueman-applet.enable = true;
  };
}
