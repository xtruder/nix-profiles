{ config, pkgs, lib, ... }:

{
  config = {
    virtualisation.docker = {
      enable = true;
      extraOptions = "--dns 172.17.0.1";
    };
    networking.firewall = {
      trustedInterfaces = [ "docker0" ];
      interfaces.docker0 = {
        allowedTCPPorts = [53 9053];
        allowedUDPPorts = [53 9053];
      };
    };
  };
}
