# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ config, pkgs, lib, nix-profiles, ... }:

{
  imports = with nix-profiles.lib.nixos; [
    # import iso environment
    environments.iso

    # enable base role
    roles.base

    # enable user profile
    profiles.user

    # enable several profiles
    profiles.openssh
    profiles.yubikey
    profiles.nix
  ];

  home-manager.users.user = {config, ...}: {
    imports = with nix-profiles.lib.home-manager; [
      roles.base

      profiles.git
      profiles.ssh
      profiles.gpg
      profiles.vim
    ];
  };

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization  ];

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];
}
