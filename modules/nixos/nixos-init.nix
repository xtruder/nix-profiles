{ pkgs, lib, ... }:

with lib;

let
  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

  nixos-init = makeProg {
    name = "nixos-init";
    src = ./nixos-init.sh;
    path = with pkgs; makeBinPath [ coreutils openssh git ];
  };
in {
  config = {
    environment.systemPackages = [ nixos-init ];
  };
}
