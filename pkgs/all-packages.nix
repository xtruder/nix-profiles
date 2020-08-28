{ pkgs }: {
  nix-firefox-addons-generator = pkgs.haskellPackages.callPackage ./firefox-addons-generator { };
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv; };
  firefox-ghacks-user-js = pkgs.callPackage ./firefox-ghacks-user-js { };
  my-vscode-extensions = pkgs.callPackage ./vscode-extensions { };
  base16-unclaimed-schemes = pkgs.callPackage ./base16-unclaimed-schemes { };
  base16-rofi = pkgs.callPackage ./base16-rofi { };
  base16-shell = pkgs.callPackage ./base16-shell { };
  materia-theme = pkgs.callPackage ./materia-theme { };
  #nixfmt = pkgs.callPackage ./nixfmt { };
  firejail = pkgs.firejail.overrideDerivation (d: {
    postInstall = ''
      rm $out/etc/firejail/firejail.config
      ln -s /etc/firejail/firejail.config $out/etc/firejail/firejail.config
    '';
  });
  i3-sway-scripts = pkgs.callPackage ./i3-sway-scripts { };
  bm-input = pkgs.callPackage ./bm-input { };
  sockproc = pkgs.callPackage ./sockproc { };
  rofi-pass = pkgs.rofi-pass.overrideDerivation (d: {
    patches = [(pkgs.fetchpatch {
      url = "https://github.com/carnager/rofi-pass/commit/4582d8f9640f6bee3141760570658a2206706ef8.patch";
      sha256 = "/NRuexG2nYZkWwqa/BWr/1dqmOkqUNWO5SpIwNgHXms=";
    })];

    postPatch = ''
      substituteInPlace rofi-pass --replace "wl-copy -o" "wl-copy"
    '';
  });
  mathpix-ocr-latex = pkgs.callPackage ./mathpix-ocr-latex { };
}
