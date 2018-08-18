{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.vm;
in {
  options.roles.vm = {
    enable = mkEnableOption "vm role";
  };

  config = mkIf config.roles.vm.enable {
    profiles.i3 = {
      enable = true;
      primaryMonitor = "Virtual-1";
      secondaryMonitor = "Virtual-2";
      screenLock.enable = false;
    };
    roles.work.enable = true;
    roles.system.enable = true;

    profiles.x11.compositor = false;
    services.xserver.displayManager.slim = {
        defaultUser = "offlinehacker";
        autoLogin = true;
    };

    services.openssh.enable = true;

    # security lies elsewhere
    security.sudo.wheelNeedsPassword = false;

    # eth0 is by default external interface
    networking.nat.externalInterface = mkDefault "eth0";
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
