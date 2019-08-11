{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.vm;
in {
  options.roles.vm = {
    enable = mkEnableOption "vm role";
  };

  config = mkIf config.roles.vm.enable {
    roles.workstation.enable = true;
    roles.work.enable = true;
    roles.system.enable = true;

    attributes.networking.primaryInterface = mkDefault "ens4";
    attributes.hardware.isVM = true;

    services.xserver.displayManager.slim = {
      defaultUser = config.users.users.admin.name;
      autoLogin = true;
    };

    # enable openssh on servers
    services.openssh.enable = true;

    # security lies elsewhere
    security.sudo.wheelNeedsPassword = false;

    # eth0 is by default external interface
    networking.nat.externalInterface = mkDefault "eth0";
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
