{ stdenv, fetchurl, bemenu }:

stdenv.mkDerivation rec {
  pname = "bemenu";
  version = builtins.substring 0 8 rev;
  rev = "3f496cbf957969259e6930d2625d4aacedb5ad34";

  src = fetchurl {
    url = "https://gist.github.com/progandy/2c05fc5f0b4e76d92002263776549bd1/archive/${rev}.tar.gz";
    sha256 = "adCjJJ+Rw1lue98kf0BcFm00GYw1KJW5pMZBpHLsUgY=";
  };

  buildInputs = [ bemenu ];

  buildPhase = ''
    gcc -o bm-input -lbemenu bm-input.c
  '';

  installPhase = ''
    install -Dm755 -t $out/bin bm-input
  '';
}
