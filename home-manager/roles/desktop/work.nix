{ pkgs, ... }:

let

  browser = ["firefox.desktop"];
  textProcessor = ["writer.desktop"];
  spreadsheet = ["impress.desktop"];
  torrent = ["transmission-gtk.desktop"];

in {
  imports = [
    ../work.nix
    ./gnome-apps.nix

    ../../profiles/firefox
    ../../profiles/chromium.nix
  ];

  config = {
    xdg.mimeApps.defaultApplications = {
      "text/html" = browser;
      "application/x-bittorrent" = torrent;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = textProcessor;
      "application/msword" = textProcessor;
      "application/vnd.oasis.opendocument.text" = textProcessor;
      "text/csv" = spreadsheet;
      "application/vnd.oasis.opendocument.spreadsheet" = spreadsheet;
    };

    home.packages = with pkgs; [
      # documents and images
      mupdf
      libreoffice
      feh
      gimp
      cdrkit

      # torrent
      transmission-gtk

      unetbootin

      tor-browser-bundle-bin
    ];
  };
}
