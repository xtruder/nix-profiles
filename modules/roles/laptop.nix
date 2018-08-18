{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.laptop.enable = mkEnableOption "laptop role";

  config = mkIf config.roles.laptop.enable {
    roles.work.enable = true;
    roles.system.enable = true;

    profiles.x11.enable = mkDefault true;
    profiles.i3.enable = mkDefault true;
    profiles.dunst.enable = mkDefault true;

    # enable libvirt profile by default on all work machines
    profiles.libvirt.enable = mkDefault true;

    # by default enable bluetooth on laptops
    hardware.bluetooth.enable = mkDefault true;

    # by default enable audio on laptops
    hardware.pulseaudio.enable = mkDefault true;

    # Do not turn off when clousing laptop lid
    services.logind.extraConfig = ''
      HandleLidSwitch=ignore
    '';

    # redshift
    services.redshift.enable = true;
    services.redshift.latitude = "46";
    services.redshift.longitude = "14";

    environment.systemPackages = with pkgs; [
      wirelesstools
      iw
    ];

    # check battery every 60s
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
