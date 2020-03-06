{ lib, ... }:

with lib;

{
  config = {
    nix = {
      # do builds in sandbox by default
      useSandbox = mkDefault true;

      # set explicit binary cache and add additional binary caches
      binaryCaches = [
        "https://cache.nixos.org/"
        "https://xtruder-public.cachix.org"
      ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "xtruder-public.cachix.org-1:+qG/fM2195QJcE2BXmKC+sS4mX/lQHqwjBH83Rhzl14="
      ];
    };
  };
}
