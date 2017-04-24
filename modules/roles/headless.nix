{ config, lib, utils, pkgs, ... }:

with lib;

let
  cfg = config.roles.headless;

in {
  options.roles.headless = {
    enable = mkOption {
      description = "Whether to enable development profile";
      default = false;
      type = types.bool;
    };

    mmap = mkOption {
      description = "Whether to use direct memory access for faster transport";
      default = true;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    profiles.x11.enable = true;

    environment.variables.DISPLAY = ":0";
    environment.variables.XAUTHORITY = "";
    environment.variables.DBUS_SESSION_BUS_ADDRESS = "";

    services.xserver = {
      enable = true;
      displayManager = {
        xpra.enable = true;
        xpra.auth = "none";
        xpra.bindTcp = "0.0.0.0:10000";
        xpra.extraOptions = ["--start-new-commands=yes"] ++ optionals cfg.mmap [
          "--mmap='/sys/devices/pci0000:00/0000:00:07.0/resource2'"
        ];
        slim.enable = false;
      };
    };

    networking.firewall.allowedTCPPorts = [ 10000 ];

    environment.systemPackages = with pkgs; [rofi rofi-pass st xterm];

    boot.postBootCommands = mkIf cfg.mmap ''
      echo 1 > /sys/devices/pci0000:00/0000:00:07.0/enable
    '';
  };
}
