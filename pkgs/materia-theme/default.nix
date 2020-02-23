{ stdenv, fetchFromGitHub, writeTextFile
, sassc, bc, which, inkscape, optipng
, colors ? null, themeName ? null }:

with stdenv.lib;

let
  colorsConfig = writeTextFile {
    name = "materia-theme-colors";
    text = concatStringsSep "\n" (mapAttrsToList (k: v: let
      v' =
        if isBool v then if v
        then "True" else "False"
        else toString v;
    in "${k}=${v'}") colors);
  };

in stdenv.mkDerivation rec {
  pname = "materia-theme${optionalString (themeName != null) "-${themeName}"}";
  version = "20201402-${substring 0 7 rev}";
  rev = "b1e4c563146ae34fff6a697393b6a1bc66b612f5";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    sha256 = "1w65v7jl8v5h41d27gj79rnkbn8rw0avrj4gi57l8lvlhpn9q6a2";
    inherit rev;
  };

  buildInputs = [ sassc bc which inkscape optipng ];

  installPhase = ''
    HOME=/build
    chmod 777 -R .
    patchShebangs .
    mkdir -p $out/share/themes
    ${if (colors == null) then ''
    ./install.sh --dest $out/share/themes ${optionalString (themeName != null) "--name ${themeName}"}
    '' else ''
    echo "Changing colours:"
    ./change_color.sh -t $out/share/themes ${optionalString (themeName != null) "-o ${themeName}"} ${colorsConfig}
    ''}
    chmod 555 -R .
  '';
}
