{ stdenv, lib, makeWrapper, fetchurl
, curl, jq, wl-clipboard, libnotify }:

stdenv.mkDerivation rec {
  pname = "mathpix-ocr-latex";
  version = builtins.substring 0 7 rev;
  rev = "3bc3aaab31c5e6de593283380f04e459017ec956";

  src = fetchurl {
    url = "https://gist.github.com/offlinehacker/7a91c7d423b030e96b1d32e126b175fb/archive/${rev}.tar.gz";
    sha256 = "b8e67711ef62a778d7caa7bba97699720e9b4fd6ab2324b8258a8fe8babf61ae";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    patchShebangs ./mathpix-ocr-latex.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./mathpix-ocr-latex.sh $out/bin/mathpix-ocr-latex

    wrapProgram "$out/bin/mathpix-ocr-latex" \
      --prefix PATH ":" "${lib.makeBinPath [ curl jq wl-clipboard libnotify ]}"
  '';
}
