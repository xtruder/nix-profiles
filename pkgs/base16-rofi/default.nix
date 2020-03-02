{ stdenv, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "base16-rofi";
  version = "20200203-${substring 0 7 rev}";
  rev = "afbc4b22d8f415dc89f36ee509ac35fb161c6df4";

  src = fetchFromGitHub {
    owner = "0xdec";
    repo = "base16-rofi";
    sha256 = "1f9gkfc4icdgdj0fkkgg1fw3n6imlr1sbi42qm9hbkjxy5fmzay2";
    inherit rev;
  };

  installPhase = ''
    mkdir -p $out
    cp themes/* $out
  '';
}
