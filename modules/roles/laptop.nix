{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.laptop.enable = mkEnableOption "laptop role";

  config = mkIf config.roles.laptop.enable {
    roles.system.enable = true;
    roles.workstation.enable = true;

    profiles.libvirt.enable = mkDefault true;
    profiles.bluetooth.enable = mkDefault true;
    profiles.udisks.enable = false;

    # enable suspend
    powerManagement.enable = mkDefault true;

    # show battery status
    profiles.i3.i3Status = {
      enableBlocks = [
        (mkOrder 511 "battery 0")
        (mkOrder 550 "tztime local")
        (mkOrder 551 "tztime pst")
      ];

      blocks.battery_0 = {
        type = "battery";
        name = "0";
        opts = {
          format = "%status %percentage %remaining";
          low_threshold = 10;
          last_full_capacity = true;
        };
      };

      blocks.tztime_local = {
        type = "tztime";
        name = "local";
        opts.format = "%Y-%m-%d ⌚ %H:%M:%S";
      };

      blocks.tztime_pst = {
        type = "tztime";
        name = "pst";

        opts = {
          format = "PST⌚ %H:%M";
          timezone = "America/Los_Angeles";
        };
      };
    };

    # enable redshift on workstation machines
    services.redshift = {
      enable = mkDefault true;
      latitude = mkDefault "46";
      longitude = mkDefault "14";
      brightness.night = mkDefault "0.8";
    };

    # Do not turn off when clousing laptop lid
    services.logind.extraConfig = ''
      HandleLidSwitch=ignore
    '';

    environment.systemPackages = with pkgs; [
      wirelesstools
    ];

    # check battery every 60s and shutdown if below 5%
    systemd.services.check-battery = {
      description = "Shutdown on low battery";
      script = ''
        ${pkgs.acpi}/bin/acpi -b | ${pkgs.gawk}/bin/awk -F'[,:%]' '{print $2, $3}' | (
          read -r status capacity
	        if [ "$status" = Discharging ] && [ "$capacity" -lt 5 ]; then
          	${pkgs.systemd}/bin/systemctl poweroff
  	      fi
        )
      '';
    };

    systemd.timers.check-battery = {
      timerConfig = {
        OnUnitInactiveSec = "60s";
        OnBootSec = "1min";
        Unit = "check-battery.service";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
