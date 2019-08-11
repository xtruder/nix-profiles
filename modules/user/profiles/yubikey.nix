{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.yubikey.enable = mkEnableOption "yubikey profile";

  config = mkIf config.profiles.yubikey.enable {
    home.packages = with pkgs; (mkMerge [
      [
        yubikey-personalization
      ]

      (mkIf config.attributes.hasGui [
        yubikey-personalization-gui
      ])
    ]);

    nixos.passthru = {
      services.udev.packages = with pkgs; [ libu2f-host yubikey-personalization ];
      users.extraGroups.yubikey = {};
      users.groups.yubikey.members = [ config.home.username ];
    };
  };
}
