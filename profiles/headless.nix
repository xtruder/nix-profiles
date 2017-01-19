{ config, lib, utils, pkgs, ... }:

with lib;

let
  cfg = config.profiles.headless;

  gottyConfig = pkgs.writeText "gotty.conf" ''
    preferences {
      background_color = "rgb(7, 54, 66)"
      color_palette_overrides = ["#073642","#dc322f","#859900","#b58900","#268bd2","#d33682","#2aa198","#eee8d5","#002b36","#cb4b16","#586e75","#657b83","#839496","#6c71c4","#93a1a1","#fdf6e3"]
      font_size = 13
    }
  '';
in {
  options.profiles.headless = {
    enable = mkOption {
      description = "Whether to enable development profile";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    profiles.work.enable = mkDefault true;

    systemd.services.gotty = {
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = "${pkgs.gotty}/bin/gotty -w -a 127.0.0.1 -p 8022 --config ${gottyConfig} /var/run/current-system/sw/bin/tmux attach";
      serviceConfig.User = "offlinehacker";
      serviceConfig.WorkingDirectory = "/home/offlinehacker";
      environment.TERM = "xterm-256color";
    };

    systemd.services.chromium = {
      wantedBy = ["multi-user.target"];
      after = ["display-manager.service"];
      environment.DISPLAY = ":0";
      serviceConfig = {
        ExecStart = "${pkgs.chromium}/bin/chromium";
        User = "offlinehacker";
        Group = "users";
      };
    };

    environment.variables.DISPLAY = ":0";

    services.xserver.enable = true;
    services.xserver.displayManager.xpra.enable = true;
    services.xserver.displayManager.xpra.bindTcp = "0.0.0.0:10000";
    services.xserver.displayManager.slim.enable = false;

    networking.firewall.allowedTCPPorts = [ 10000 ];

    environment.systemPackages = with pkgs; [rofi rofi-pass];
  };
}
