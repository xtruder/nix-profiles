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
    services.gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };

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
