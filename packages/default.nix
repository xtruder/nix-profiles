{ pkgs }:

{
  bundles = import ./bundles.nix { inherit pkgs; };
}
