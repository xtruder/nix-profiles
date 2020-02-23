# firware role includes firmware related stuff

{ config, lib, ... }:

with lib;

{
  config = {
    # enable firmware updates on all workstations, since this should be sane thing to do
    services.fwupd.enable = mkDefault true;

    # enable all firmware
    hardware.enableAllFirmware = mkDefault true;
  };
}
