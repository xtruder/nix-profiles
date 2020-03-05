{ config, lib, ... }:

with lib;

{

  config = {
    attributes.hardware.isVM = true;

    # enable openssh on server in vm
    services.openssh.enable = mkDefault true;

    # eth0 is by default external interface
    networking.nat.externalInterface = mkDefault "eth0";
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
