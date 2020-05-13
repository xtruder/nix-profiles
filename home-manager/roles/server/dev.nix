{ pkgs, ... }:

{
  imports = [
    ../dev.nix

    ../../profiles/code-server.nix
  ];
}
