{ config, lib, pkgs, ... }:

with lib;

{
  options.roles.workstation.enable = mkEnableOption ''
    workstation profiles defines base for all graphical workstation machines
  '';

  config = mkIf config.roles.workstation.enable {
    roles.system.enable = true;

    profiles.x11.enable = mkDefault true;
    profiles.i3 = {
      enable = mkDefault true;
      i3Status = {
        enableBlocks = [
          (mkOrder 500 "online_status")
          (mkOrder 510 "disk /")
          (mkOrder 520 "load")
          (mkOrder 530 "net_rate")
          (mkOrder 540 "volume master")
        ];

        blocks.general.opts = {
          output_format = "i3bar";
          colors = true;
          interval = 5;
        };

        blocks.net_rate.opts = {
          interfaces = "ens3,ens4,wlan0,eth0";
          all_interfaces = false;
          si_units = true;
        };

        blocks.load.opts = {
          format = "↺ %1min";
        };

        blocks.disk_root = {
          type = "disk";
          name = "/";
          opts = {
            format = "√ %free";
          };
        };

        blocks.volume_master = {
          type = "volume";
          name = "master";
          opts = {
            format = "♪ %volume";
            device = "default";
            mixer = "Master";
            mixer_idx = 0;
          };
        };

        blocks.online = {};
      };
    };
    profiles.dunst.enable = mkDefault true;
    profiles.networkmanager.enable = mkDefault true;
    profiles.udisks.enable = mkDefault true;
    profiles.pulseaudio.enable = mkDefault true;

    services.dbus.enable = true;

    # run these commands as session commands if running without desktop
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
    '';

    # gnome keyring is needed for saving some secrets
    services.gnome3.gnome-keyring.enable = mkDefault true;

    # Polkit allow kexec
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.policykit.exec") &&
            subject.local && subject.active && subject.isInGroup("users")) {
                return polkit.Result.YES;
        }
      });
    '';
  };
}
