{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.work.enable = mkEnableOption "work role";

  config = mkIf config.roles.work.enable {
    home-manager.users.admin.roles.work.enable = true;

    services.earlyoom.enable = mkDefault true;

    profiles.printingAndScanning.enable = mkDefault true;
  };
}
