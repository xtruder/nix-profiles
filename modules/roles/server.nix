{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.server.enable = mkEnableOption "server role";

  config = mkIf config.roles.server.enable {
    roles.system.enable = mkDefault true;

    services.openssh.enable = true;

    networking.firewall.allowedTCPPorts = [22];
  };
}
