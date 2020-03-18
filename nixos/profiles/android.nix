{ config, pkgs, ... }:

{
  config = {
    services.udev.packages = [ pkgs.android-udev-rules ];
    users.groups.adbusers = {};
  };
}
