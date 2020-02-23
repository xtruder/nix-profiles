{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../apps/gpg.nix
    ../apps/tmux.nix
    ../apps/udiskie.nix
    ../apps/xterm.nix
    ../apps/firefox

    ./graphics.nix
  ];

  config = {
    dconf.enable = true;

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
