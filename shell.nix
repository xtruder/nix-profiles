{ sources ? import ./nix/sources.nix, pkgs ? import sources.nixpkgs {} }:

with pkgs.lib;

let
  NIX_PATH = concatStringsSep ":" (mapAttrsToList (k: v: "${k}=${v}") (filterAttrs (n: _: n != "__functor") sources));
in pkgs.mkShell {
  buildInputs = with pkgs; [ niv git ];

  shellHook = ''
    export NIX_PATH=nix-profiles=$PWD:${NIX_PATH}
  '';
}
