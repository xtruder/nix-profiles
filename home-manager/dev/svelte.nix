{ config, pkgs, ... }:

{
  imports = [ ./node.nix ];

  config = {
    programs.vscode = {
      extensions = [
        pkgs.my-vscode-extensions.svelte-vscode
      ];
    };
  };
}
