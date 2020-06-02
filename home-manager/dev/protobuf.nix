{ config, ... }:

{
  imports = [ ./base.nix ];

  config = {
    programs.vscode = {
      extensions = [
        pkgs.my-vscode-extensions.vscode-proto3
      ];
    };

    home.packages = with pkgs; [
      protobuf
      go-protobuf
    ];
  };
}
