{ config, lib, ... }:

with lib;

let
  sources = import ../../nix/sources.nix;
  convertSrc = src:
    if src.type == "tarball" && hasPrefix "https://github.com" src.url
    then "https://github.com/${src.owner}/${src.repo}/archive/${src.branch}.tar.gz"
    else src;
  nixPath = mapAttrs (_: s: mkDefault (convertSrc s)) (filterAttrs (n: _: n != "__functor") sources);

in {
  options.nix.nixPathAttrs = mkOption {
    type = types.attrsOf types.str;
    description = "Attribute set of nix path";
  };

  config = {
    nix.nixPathAttrs = nixPath // {
      nixos-config = "/etc/nixos/configuration.nix";
    };
    nix.nixPath = mapAttrsToList (n: v: "${n}=${v}") config.nix.nixPathAttrs;
  };
}
