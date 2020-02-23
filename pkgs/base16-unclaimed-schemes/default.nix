{ stdenv, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "base16-unclaimed-schemes";
  version = "20201302-${substring 0 7 rev}";
  rev = "d6b93456dc1012628faec572387814f59e0b854a";

  src = fetchFromGitHub {
    owner = "chriskempson";
    repo = "base16-unclaimed-schemes";
    sha256 = "043ny56snl4w2ri1i0zzfh00zm2gf2h5jz57kgmf5jb9xj0sspb1";
    inherit rev;
  };

  installPhase = ''
    mkdir -p $out
    cp * $out
  '';
}
