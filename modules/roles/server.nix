{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.server.enable = mkEnableOption "server role";

  config = mkIf config.roles.server.enable {
    roles.system.enable = mkDefault true;

    services.openssh.enable = true;

    networking.firewall.allowedTCPPorts = [22];

    # eth0 is by default external interface
    networking.nat.externalInterface = mkDefault "eth0";
  };
}
