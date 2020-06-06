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

  # enable sysdig on all systems
  programs.sysdig.enable = true;

  # enable bcc tools on all systems: https://github.com/iovisor/bcc
  programs.bcc.enable = true;
}
