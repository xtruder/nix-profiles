{ mkDerivation, aeson, base-noprelude, directory, fetchgit, hnix
, lens, lens-aeson, relude, stdenv, text, wreq }:

mkDerivation rec {
  pname = "nixpkgs-firefox-addons";
  version = "v0.2.0";
  src = fetchgit {
    url = "https://gitlab.com/rycee/nixpkgs-firefox-addons";
    rev = version;
    sha256 = "1pirpkbm3r7xardp8rzv17y19ynxl40scgajsps6gxplmxyzpaq7";
    fetchSubmodules = false;
  };
  isLibrary = false;
  isExecutable = true;
  enableSeparateDataOutput = true;
  executableHaskellDepends = [
    aeson base-noprelude directory hnix lens lens-aeson relude text
    wreq
  ];
  homepage = "https://gitlab.com/rycee/nix-firefox-addons";
  description = "Tool generating a Nix package set of Firefox addons";
  license = stdenv.lib.licenses.gpl3;
  maintainers = with stdenv.lib.maintainers; [ rycee ];
}
