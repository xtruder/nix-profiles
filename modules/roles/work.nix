{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.work.enable = mkEnableOption "work role";

  config = mkIf config.roles.work.enable {
    # Chromium settings
    programs.chromium = {
      enable = mkDefault true;
      homepageLocation = mkDefault "https://encrypted.google.com";
      defaultSearchProviderSearchURL = mkDefault
        "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
      defaultSearchProviderSuggestURL = mkDefault
        "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
      extensions = [
        "klbibkeccnjlkjkiokjodocebajanakg" # the great suspender
        "chlffgpmiacpedhhbkiomidkjlcfhogd" # pushbullet
        "mbniclmhobmnbdlbpiphghaielnnpgdp" # lightshot
        "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "naepdomgkenhinolocfifgehidddafch" # browserpass
        "kajibbejlbohfaggdiogboambcijhkke" # mailvelope
      ];
    };

    programs.browserpass.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableExtraSocket = false;
      enableBrowserSocket = false;
    };

    # enable tmux on work environments
    profiles.tmux.enable = mkDefault true;

    # yubikey support
    services.udev.packages = with pkgs; [ libu2f-host  ];
    users.extraGroups.yubikey = {};
    services.udev.extraRules = ''
      ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0111", MODE="664", GROUP="yubikey"
    '';

    environment.systemPackages = with pkgs; [
      mupdf
      libreoffice
      feh
      gimp

      # browsers
      chromium
      rambox

      # distro tools
      cdrkit
      unetbootin

      # cloud storage
      #dropbox
      #dropbox-cli

      # windows emulation
      wine
      winetricks
      dosbox

      # p2p stuff
      transmission_gtk

      # docs/images
      mupdf

      # audio/video
      vlc
      xvidcap
      ffmpeg
      nodePackages.peerflix
      youtube-dl

      # remote
      rdesktop
      gtk-vnc
      virtmanager
      virtviewer

      gnome3.dconf

      # crypto
      gnupg
      libnotify
      update-resolv-conf

      # yubikey
      yubikey-personalization
      yubikey-personalization-gui
    ];

    environment.pathsToLink = [
      "/libexec/openvpn"
    ];
  };
}
