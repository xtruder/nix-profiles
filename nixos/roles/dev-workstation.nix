# dev-worksation role defines role used for development, extends work role

{ config, ... }:

{
  imports = [
    ./workstation.nix

    ../profiles/libvirt.nix
    ../profiles/docker.nix
    ../profiles/android.nix
    ../profiles/nix-dev.nix
  ];
}
