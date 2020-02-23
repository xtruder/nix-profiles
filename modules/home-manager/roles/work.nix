{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../apps/dunst.nix
    ../apps/gpg.nix
    ../apps/i3.nix
    ../apps/i3status.nix
    ../apps/tmux.nix
    ../apps/udiskie.nix
    ../apps/xterm.nix
    ../apps/firefox
  ];

  config = {
    home.packages = with pkgs; (mkMerge [
      [
        # fetch tools
        aria

        # distro tools
        cdrkit

        # shell tools
        pet
        fzf

        # cloud storage
        #dropbox
        #dropbox-cli

        # windows emulation
        wine
        winetricks

        # crypto
        gnupg

        # vpn
        protonvpn-cli

        jrnl

        google-drive-ocamlfuse
      ]

      (mkIf config.attributes.hasGui [
        # docs/images
        mupdf
        libreoffice
        feh
        gimp

        # distro tools
        unetbootin
      ])
    ]);
  };
}
