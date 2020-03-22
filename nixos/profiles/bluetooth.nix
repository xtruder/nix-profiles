{ config, ... }:

{
  config = {
    # enable bluetooth support on all workstations
    hardware.bluetooth.enable = true;

    # enable system blueman service
    services.blueman.enable = true;
  };
}
