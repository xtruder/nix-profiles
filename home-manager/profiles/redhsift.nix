{ config, lib, ... }:

with lib;

{
  config = {
    services.redshift = {
      enable = true;
      provider = "geoclue2";
      brightness.night = mkdefault "0.8";
    };
  };
}
