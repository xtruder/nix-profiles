{ pkgs, ... }:

{
  imports = [
    ../work.nix

    ../../apps/firefox
  ];

  config = {
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
