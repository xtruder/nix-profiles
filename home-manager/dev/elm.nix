{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./node.nix ];

  config = {
    programs.vscode.extensions = with pkgs.my-vscode-extensions; [
      elm
      vscode-elm-jump
    ];

    home.packages = with pkgs; [
      elmPackages.elm
    ];
  };
}
