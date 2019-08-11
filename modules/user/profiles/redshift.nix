{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.redshift;
in {
  options.profiles.redshift.enable = mkEnableOption "redshift profile";

  config = mkIf cfg.enable {
    services.redshift = {
      enable = true;
      provider = "geoclue2";
      brightness.night = mkDefault "0.8";
    };

    nixos.passthru.services.geoclue2.enable = true;
  };
}
