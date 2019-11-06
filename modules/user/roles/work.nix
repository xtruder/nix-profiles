{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.work.enable = mkEnableOption "work role for work related stuff";

  config = mkIf config.roles.work.enable {
    profiles = {
      chromium.enable = true;
      firefox.enable = true;
      pulseaudio.enable = true;
      bluetooth.enable = true;
      udisks.enable = true;
      dunst.enable = true;
      network-manager.enable = true;
      xterm.enable = true;
      tmux.enable = true;
      vim.enable = true;
      redshift.enable = true;
      xsuspender.enable = true;
      yubikey.enable = true;
    };

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
