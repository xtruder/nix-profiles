# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ config, pkgs, lib, nix-profiles, ... }:

{
  imports = with nix-profiles.nixos; [
    roles.base
    profiles.user
    system.iso
  ];

  home-manager.users.user = {
    programs = {
      gpg.enable = true;
    };
  };

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization  ];

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];
}
