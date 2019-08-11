{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.udisks;
in {
  options.profiles.udisks = {
    enable = mkEnableOption "udisks profile";
  };

  config = mkIf cfg.enable {
    nixos.passthru = {
      profiles.udisks.enable = true;
    };

    services.udiskie = {
      enable = true;
      automount = false;
      notify = true;
    };
  };
}
