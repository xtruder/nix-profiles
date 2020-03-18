{ lib, ... }:

with lib;

{
  config = {
    services.udiskie = {
      enable = mkDefault true;
      automount = false;
      notify = true;
      tray = "always";
    };
  };
}
