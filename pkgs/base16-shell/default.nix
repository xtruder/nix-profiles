{ stdenv, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "base16-shell";
  version = "20191606-${substring 0 7 rev}";
  rev = "ce8e1e540367ea83cc3e01eec7b2a11783b3f9e1";

  src = fetchFromGitHub {
    owner = "chriskempson";
    repo = "base16-shell";
    sha256 = "1yj36k64zz65lxh28bb5rb5skwlinixxz6qwkwaf845ajvm45j1q";
    inherit rev;
  };

  installPhase = ''
    patchShebangs .
    patchShebangs scripts/

    mkdir -p $out
    cp -r * $out
  '';
}
