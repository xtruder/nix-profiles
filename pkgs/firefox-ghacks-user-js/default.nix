{ stdenv, lib, fetchFromGitHub, gnused, firefox }:

with lib;

let
  majorFFVersion = versions.majorMinor (getVersion firefox);

  versionMapping = {
    "72.0" = {
      rev = "72.0";
      sha256 = "043ydzj4llndhx7lhl5yf6hvcj7ci186myyfiakrl2k43imnzknc";
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

  buildInputs = [ gnused ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    sed -f ${./user_js_to_nix.sed} user.js > user.nix
  '';

  installPhase = ''
    mkdir -p $out
    cp user.{js,nix} $out
  '';
}
