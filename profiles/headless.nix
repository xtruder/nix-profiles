{ config, lib, utils, pkgs, ... }:

with lib;

let
  cfg = config.profiles.headless;
in {
  options.profiles.headless = {
    enable = mkOption {
      description = "Whether to enable development profile";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gotty = {
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = "${pkgs.gotty}/bin/gotty -w -a 0.0.0.0 -p 8022 /var/run/current-system/sw/bin/tmux attach";
      serviceConfig.User = "offlinehacker";
      environment.TERM = "xterm-256color";
    };

    services.xserver.enable = true;
    services.xserver.displayManager.xpra.enable = true;
    services.xserver.displayManager.xpra.bindTcp = "0.0.0.0:10000";
    services.xserver.displayManager.slim.enable = false;

    networking.firewall.allowedTCPPorts = [ 8022 10000 ];
  };
}
