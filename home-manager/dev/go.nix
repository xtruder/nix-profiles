{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./base.nix ];

  config = {
    home.packages = with pkgs; [
      go
      glide
      dep
      dep2nix
      go2nix
      vgo2nix
      go-protobuf

      # editor support
      go-tools # honnef.co/go/tools/...@latest
      gotools # golang.org/x/tools
      golint # golang.org/x/lint
      gocode # github.com/mdempsky/gocode
      gocode-gomod # github.com/stamblerre/gocode
      gotests # github.com/cweill/gotests
      # goplay
      # goreturns
      impl # github.com/josharian/impl
      reftools # github.com/davidrjenni/reftools/cmd/fillstruct
      gopkgs # github.com/uudashr/gopkgs/v2/cmd/gopkgs
      go-outline # github.com/ramya-rao-a/go-outline
      go-symbols # github.com/acroca/go-symbols
      # godoctor # github.com/godoctor/godoctor
      godef # github.com/rogpeppe/godef
      gogetdoc # github.com/zmb3/gogetdoc
      gomodifytags # github.com/fatih/gomodifytag
      # revieve # github.com/mgechev/revive
      delve # github.com/go-delve/delve/cmd/dlv
      gomove
      gore # golang repl: github.com/motemen/gore
      gopls
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
