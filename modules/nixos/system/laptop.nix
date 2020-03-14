# laptop role is used on all portable laptop machines

{ config, lib, ... }:

with lib;

{
  imports = [ ../profiles/low-battery.nix ];

  config = {
    # enable suspend
    powerManagement.enable = mkDefault true;

    # for power optimizations
    powerManagement.powertop.enable = true;

    # enable TLP daemon for power saving
    services.tlp.enable = true;

    # Do not turn off when closing laptop lid
    services.logind.extraConfig = ''
      HandleLidSwitch=ignore
    '';

    attributes.hardware.hasBattery = true;
  };
}
