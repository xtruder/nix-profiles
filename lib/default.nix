{ pkgs, lib }:

# extend existing library with additional methods
lib.extend (lib: self:
  # add utility methods
  (import ./util.nix { inherit pkgs; lib = self; })
)
