{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.udisks.enable = mkEnableOption "udisks profile";

  config = mkIf config.profiles.udisks.enable {
    services.udisks2.enable = true;
  };
}
