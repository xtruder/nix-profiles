{ lib, ... }:

with lib;

{
  config = {
    services.redshift = {
      enable = mkDefault true;
      provider = "geoclue2";
      brightness.night = mkDefault "0.8";
      tray = true;
    };
  };
}
