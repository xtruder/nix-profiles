{ config, lib, pkgs, ... }:

with lib;
with (import ../../../lib/util.nix { inherit pkgs lib; });
with (import ../../../nix/sources.nix);

{
  imports = [
    ./base.nix

    (loadPath
      <np-nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    (loadPath
      <np-nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  config = {
    attributes = {
      name = mkDefault "nixos";
      project = mkDefault "x-truder.net";
    };
  };
}
