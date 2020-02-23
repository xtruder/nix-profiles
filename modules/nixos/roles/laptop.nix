# laptop role is used on all portable laptop machines

{ config, lib, ... }:

with lib;

{
  imports = [
    ./base.nix
  ];

  config = {
    # enable suspend
    powerManagement.enable = mkDefault true;

    # for power optimizations
    powerManagement.powertop.enable = true;

    # enable TLP daemon for power saving
    services.tlp.enable = true;

    # Do not turn off when closing laptop lid
    services.logind.extraConfig = ''
      HandleLidSwitch=ignore
    '';

    # check battery every 60s and shutdown if below 5%
    systemd.services.check-battery = {
      description = "Shutdown on low battery";
      path = with pkgs; [ gawk acpi systemd ];
      script = ''
        acpi -b | awk -F'[,:%]' '{print $2, $3}' | (
          read -r status capacity
	        if [ "$status" = Discharging ] && [ "$capacity" -lt 5 ]; then
          	systemctl poweroff
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
