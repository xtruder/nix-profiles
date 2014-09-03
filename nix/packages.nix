{ pkgs ? import <nixpkgs> {} }:

with pkgs.pythonPackages;

rec {
  pythonPkgs = import ./generated.nix {
    inherit pkgs python buildPythonPackage;
    self = pythonPkgs;
    overrides = import ./overrides.nix {
      inherit python pkgs;
      self = pythonPkgs;
    };
  };

  inherit (pythonPkgs) sentry graph-explorer graphite-api;
}
