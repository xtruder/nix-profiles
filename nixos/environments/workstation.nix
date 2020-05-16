{ config, lib, ... }:

with lib;

{
  imports = [
    ../profiles/xserver.nix
    ../profiles/network-manager.nix
    ../profiles/pulseaudio.nix
    ../profiles/bluetooth.nix
    ../profiles/yubikey.nix
    ../profiles/printing.nix
    ../profiles/scanning.nix
    ../profiles/firmware.nix
  ];

  # enable pcscd daemon by default
  services.pcscd.enable = mkDefault true;

  # enable udisks2 dbus service on all work machines by default
  services.udisks2.enable = mkDefault true;

  # enable geoclue2 dbus service to get location information for apps like redshift
  services.geoclue2.enable = mkDefault true;

  # enable dconf support on all workstations for storage of configration
  programs.dconf.enable = mkDefault true;

  # changing of light
  programs.light.enable = mkDefault true;

  # hiberante on power key by default on all workstations
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
  '';
}
