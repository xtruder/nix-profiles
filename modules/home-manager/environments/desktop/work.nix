{ pkgs, ... }:

{
  imports = [
    ../work.nix

    ../../apps/firefox
    ../../apps/xterm.nix
  ];

  config = {
    dconf.enable = true;

    services.network-manager-applet.enable = true;

    home.packages = with pkgs; [
      mupdf
      libreoffice
      feh
      gimp
      cdrkit

      unetbootin

      tor-browser-bundle-bin
    ];
  };
}
