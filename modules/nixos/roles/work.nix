# work role is used for systems that are used for work

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base.nix

    ./networking.nix
    ./audio.nix
    ./bluetooth.nix
    ./android.nix
    ./xserver.nix
    ./firmware.nix
  ];

  config = {
    # add yubikey udev packages and usb-modeswitch
    services.udev.packages = with pkgs; [ libu2f-host yubikey-personalization usb-modeswitch-data ];

    # add yubikey group, all uses in yubikey group can access yubikey devices
    users.extraGroups.yubikey = {};

    # For office work we need printing support
    services.printing = {
      enable = true;

      # enable hp printers, since it's what i'm usually dealing with
      drivers = [ pkgs.hplipWithPlugin ];
    };

    # For office work we need scanners
    hardware.sane = {
      enable = true;

      # enable hp scanners, since this is what i'm usually dealing with
      extraBackends = [ pkgs.hplipWithPlugin ];
    };

    services.saned.enable = true;

    # enable pcscd daemon by default
    services.pcscd.enable = mkDefault true;

    # enable udisks2 dbus service on all work machines by default
    services.udisks2.enable = mkDefault true;

    # enable geoclue2 dbus service to get location information for apps like redshift
    services.geoclue2.enable = mkDefault true;

    # enable dconf support on all workstations for storage of configration
    programs.dconf.enable = mkDefault true;

    # hiberante on power key by default on all workstations
    services.logind.extraConfig = ''
      HandlePowerKey=hibernate
    '';

    # enable tun and fuse on work machines
    boot.kernelModules = [ "tun" "fuse" ];
  };
}
