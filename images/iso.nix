# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:

{
  imports = [
     <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    <home-manager/nixos>
  ];

  home-manager = {
    useUserPackages = true;
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
