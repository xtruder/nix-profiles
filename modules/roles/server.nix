{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.server.enable = mkEnableOption "admin role";

  config = mkIf config.roles.server.enable {
    roles.system.enable = mkDefault true;

    networking.firewall.allowedTCPPorts = [22];
  };
}
