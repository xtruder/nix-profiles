{ pkgs, ... }:

{
  imports = [
    ../dev.nix
    ./work.nix

    ../../profiles/vscode.nix
  ];
}
