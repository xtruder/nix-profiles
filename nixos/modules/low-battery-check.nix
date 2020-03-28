{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.low-battery-check;

in {
  options.services.low-battery-check = {
    enable = mkEnableOption "low battery check service";

    action = mkOption {
      description = "Action to perform when battery is low";
      type = types.enum ["poweroff" "hibernate"];
      default = "poweroff";
    };
  };

  config = mkIf cfg.enable {
    # check battery every 60s and shutdown if below 5%
    systemd.services.check-low-battery = {
      description = "Shutdown on low battery";
      path = with pkgs; [ gawk acpi systemd ];
      script = ''
        acpi -b | awk -F'[,:%]' '{print $2, $3}' | (
          read -r status capacity
	        if [ "$status" = Discharging ] && [ "$capacity" -lt 5 ]; then
          	systemctl ${cfg.action}
  	      fi
        )
      '';
    };

    systemd.timers.check-low-battery = {
      timerConfig = {
        OnUnitInactiveSec = "60s";
        OnBootSec = "1min";
        Unit = "check-low-battery.service";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
