{ stdenv, fetchFromGitHub, runtimeShell }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "sockproc";
  version = substring 0 7 rev;
  rev = "92aba736027bb5d96e190b71555857ac5bb6b2be";

  src = fetchFromGitHub {
    owner = "juce";
    repo = "sockproc";
    sha256 = "fspffnytphmpz+oR8ibRvebLVk39QYzORLJjhXOVLVc=";
    inherit rev;
  };

  buildPhase = ''
    gcc  -Wall -o sockproc sockproc.c
  '';

  patchPhase = ''
    substituteInPlace sockproc.c --replace '/bin/sh' '${runtimeShell}'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sockproc $out/bin
  '';
}
