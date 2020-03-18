{ pkgs, ... }:

{
  imports = [
    ../work.nix

    ../../profiles/firefox
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
