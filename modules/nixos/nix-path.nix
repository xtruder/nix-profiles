{ config, lib, ... }:

with lib;

let
  sources = import ../../nix/sources.nix;
  nixPath = mapAttrs (_: v: mkDefault (toString v)) (filterAttrs (n: _: n != "__functor") sources);

in {
  options.nix.nixPathAttrs = mkOption {
    type = types.attrsOf types.str;
    description = "Attribute set of nix path";
  };

  config = {
    nix.nixPathAttrs = nixPath;
    nix.nixPath = mapAttrsToList (n: v: "${n}=${v}") config.nix.nixPathAttrs;
  };
}
