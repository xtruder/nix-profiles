{ config, ... }:

{
  imports = [
    ./cloud.nix
    ./containers.nix
    ./kubernetes.nix
    ./virt.nix
    ./tools.nix
  ];
}
