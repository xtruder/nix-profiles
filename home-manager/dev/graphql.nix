{ config, pkgs, ... }:

{
  config = {
    programs.vscode = {
      extensions = [
        pkgs.my-vscode-extensions.graphql-for-vscode
      ];
    };
  };
}
