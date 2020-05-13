# work role is used for systems that are used for work

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base.nix

    ../profiles/xserver.nix
  ];
}
