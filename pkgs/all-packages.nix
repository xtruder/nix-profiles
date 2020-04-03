{ pkgs }: {
  nix-firefox-addons-generator = pkgs.haskellPackages.callPackage ./firefox-addons-generator { };
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv; };
  firefox-ghacks-user-js = pkgs.callPackage ./firefox-ghacks-user-js { };
  my-vscode-extensions = pkgs.callPackage ./vscode-extensions { };
  base16-unclaimed-schemes = pkgs.callPackage ./base16-unclaimed-schemes { };
  base16-rofi = pkgs.callPackage ./base16-rofi { };
  base16-shell = pkgs.callPackage ./base16-shell { };
  materia-theme = pkgs.callPackage ./materia-theme { };
  nixfmt = pkgs.callPackage ./nixfmt { };
  firejail = pkgs.firejail.overrideDerivation (d: {
    postInstall = ''
      rm $out/etc/firejail/firejail.config
      ln -s /etc/firejail/firejail.config $out/etc/firejail/firejail.config
    '';
  });
}
