{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.laptop.enable = mkEnableOption "laptop role";

  config = mkIf config.roles.laptop.enable {
    roles.work.enable = true;
    roles.system.enable = true;

    profiles.x11.enable = mkDefault true;
    profiles.i3.enable = mkDefault true;

    # by default enable bluetooth on laptops
    hardware.bluetooth.enable = mkDefault true;

    # by default enable audio on laptops
    hardware.pulseaudio.enable = mkDefault true;

    # Do not turn off when clousing laptop lid
    services.logind.extraConfig = ''
      HandleLidSwitch=ignore
    '';

    environment.systemPackages = with pkgs; [
      wirelesstools
    ];
  };
}
