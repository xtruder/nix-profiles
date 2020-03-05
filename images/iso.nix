# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{ config, pkgs, lib, ... }:

let
  nix-profiles = import ../. { inherit pkgs lib; };

in {
  imports = with nix-profiles.modules.nixos; [
    environment.base
    profiles.user
    hw.iso
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
