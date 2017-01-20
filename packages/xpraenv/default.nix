{ stdenv, i3, xpra, rofi, jq, gnugrep, coreutils, libnotify, makeWrapper }:

stdenv.mkDerivation {
  name = "xpraenv";

  src = { outPath = ./.; revCount = 1234; rev = "abcdef";  };

  phases = ["installPhase"];

  buildInputs = [makeWrapper];

  PREFIXPATH = stdenv.lib.makeSearchPath "bin" [i3 jq xpra coreutils gnugrep rofi libnotify];

  installPhase = ''
    mkdir -p $out/{bin,libexec/xpraenv}
    cp -R $src/{*.sh,xpraenv,i3-run} $out/libexec/xpraenv/
    makeWrapper $out/libexec/xpraenv/xpraenv $out/bin/xpraenv \
      --prefix PATH : "''$PREFIXPATH"
    makeWrapper $out/libexec/xpraenv/i3-run $out/bin/i3-run \
      --prefix PATH : "''$PREFIXPATH}"
  '';
}
