{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./base.nix ];

  config = {
    home.packages = with pkgs; [
      go_1_14
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
      gopls
      godef
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ vim-go ];

    programs.vscode = {
      userSettings = {
        "go.docsTool" = "godoc";
        "go.formatTool" = "goimports";
      };
      extensions = with pkgs.my-vscode-extensions; [
        go
      ];
    };

    home.sessionVariables = {
      GOPATH = "$HOME/projects/go";
    };
  };
}
