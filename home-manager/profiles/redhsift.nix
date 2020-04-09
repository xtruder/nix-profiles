{ lib, pkgs, ... }:

with lib;

{
  config = {
    services.redshift = {
      enable = mkDefault true;
      # redshift with wayland support
      package = pkgs.redshift-wlr;
      provider = "geoclue2";
      brightness.night = mkDefault "0.8";
      tray = true;
    };
  };
}
