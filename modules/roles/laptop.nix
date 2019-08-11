{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.laptop.enable = mkEnableOption "laptop role";

  config = mkIf config.roles.laptop.enable {
    attributes.hardware.hasBattery = true;

    roles.system.enable = true;
    roles.workstation.enable = true;

    profiles.libvirt.enable = mkDefault true;

    # enable suspend
    powerManagement.enable = mkDefault true;
    # for power optimizations
    powerManagement.powertop.enable = true;
    # enable TLP daemon for power saving
    services.tlp.enable = true;

    home-manager.users.admin.profiles.redshift.enable = true;

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
