{ config, pkgs, lib, ... }:

with lib;

{
  config = {
    home.packages = with pkgs; [
      go_1_12
      golint
      gocode
      gotags
      glide
      dep
      dep2nix
      go2nix
      vgo2nix
      gotools
      go-protobuf
    ];

    programs.vim.plugins = [ "vim-go" ];

    programs.vscode.extensions = with pkgs.my-vscode-extensions; [
      go
    ];

    home.sessionVariables = {
      GOPATH = "$HOME/projects/go";
    };
  };
}
