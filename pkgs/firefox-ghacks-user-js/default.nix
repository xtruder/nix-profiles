{ stdenv, lib, fetchFromGitHub, nodejs, firefox }:

with lib;

let
  majorFFVersion = versions.majorMinor (getVersion firefox);

  versionMapping = {
    "72.0" = {
      rev = "72.0";
      sha256 = "043ydzj4llndhx7lhl5yf6hvcj7ci186myyfiakrl2k43imnzknc";
    };
    "73.0" = {
      rev = "v73.0-beta";
      sha256 = "1z6ybi8x5b57jahalxrjsm6k61gz2lnic1d1w939jscz7z2ydd3c";
    };
    "74.0" = {
      rev = "v74.0-beta";
      sha256 = "ena5eo+mP1ieNq5JZB92QflQdE1aXAekHfTMcpAZruA=";
    };
    "75.0" = {
      rev = "v74.0-beta";
      sha256 = "ena5eo+mP1ieNq5JZB92QflQdE1aXAekHfTMcpAZruA=";
    };
    "76.0" = {
      rev = "v76.0-beta";
      sha256 = "WIYQNiTXbJuGYprs4wOdFlgoDmTkPCJZlcmmC1wpCzk=";
    };
    "77.0" = {
      rev = "v77.0-beta";
      sha256 = "X5mH/k+gU4/K1RPyQi3JkcRHyzPW2gtaeo/Wh/4gdqM=";
    };
    "79.0" = {
      rev = "v79.0-beta";
      sha256 = "BJlzp43dJUfHTaXOzo/PgO86ECYYOCx004zWz8BVvgg=";
    };
  };

  version =
    if (!versionMapping ? majorFFVersion)
    then versionMapping.${majorFFVersion}
    else throw "Unsupported version ghacks-user-js firefox version ${majorFFVersion}";

in stdenv.mkDerivation {
  pname = "ghacks-user-js";
  version = version.rev;

  src = fetchFromGitHub {
    owner = "ghacksuserjs";
    repo = "ghacks-user.js";
    rev = version.rev;
    sha256 = version.sha256;
  };

  nativeBuildInputs = [ nodejs ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    node ${./user_js_to_json.js}
  '';

  installPhase = ''
    mkdir -p $out
    cp user.{js,json} $out
  '';
}
