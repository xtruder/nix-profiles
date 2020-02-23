# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, nix-profiles, sources, ...}:

{
  imports = with nix-profiles.modules.nixos; [
    home-manager

    roles.iso
  ];

  home-manager = {
    users.root = {
      programs = {
        gpg.enable = true;
      };
    };
  };

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization  ];

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];
}
