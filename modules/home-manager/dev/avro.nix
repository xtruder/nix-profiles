{ config, pkgs, ... }:

{
  imports = [ ./base.nix ];

  config = {
    programs.vscode = {
      extensions = [
        pkgs.my-vscode-extensions.avro
      ];
    };
  };
}
