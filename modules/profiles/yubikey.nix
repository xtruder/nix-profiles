{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.yubikey.enable = mkEnableOption "yubikey profile";

  config = mkIf config.profiles.yubikey.enable {
    # yubikey support
    services.udev.packages = with pkgs; [ libu2f-host  ];
    users.extraGroups.yubikey = {};
    services.udev.extraRules = ''
      ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0111", MODE="664", GROUP="yubikey"
    '';
    users.groups.yubikey.members = ["${config.users.users.admin.name}"];

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-personalization-gui
    ];
  };
}
