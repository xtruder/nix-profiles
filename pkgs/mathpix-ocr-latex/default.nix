{ stdenv, lib, makeWrapper, fetchurl
, curl, jq, wl-clipboard, libnotify }:

stdenv.mkDerivation rec {
  pname = "mathpix-ocr-latex";
  version = builtins.substring 0 7 rev;
  rev = "62d2504755b321643077779fd36b3d714a9c66e5";

  src = fetchurl {
    url = "https://gist.github.com/offlinehacker/7a91c7d423b030e96b1d32e126b175fb/archive/${rev}.tar.gz";
    sha256 = "4fc5309eb9b63f6772dfc933993c363482ee041fa6736c9f9e5065f714c1308f";
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
