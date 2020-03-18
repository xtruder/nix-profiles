{ config, ... }:

{
  imports = [ ./base.nix ];

  config = {
    programs.vscode = {
      extensions = [
        pkgs.my-vscode-extensions.vscode-proto3
      ];
    };
  };
}
