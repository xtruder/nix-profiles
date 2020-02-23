{ pkgs }: {
  nix-firefox-addons-generator = pkgs.haskellPackages.callPackage ./firefox-addons-generator { };
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv; };
  firefox-ghacks-user-js = pkgs.callPackage ./firefox-ghacks-user-js { };
  my-vscode-extensions = pkgs.callPackage ./vscode-extensions { };
  base16-unclaimed-schemes = pkgs.callPackage ./base16-unclaimed-schemes { };
  materia-theme = pkgs.callPackage ./materia-theme { };
}
