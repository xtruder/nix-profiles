{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.go;
in {
  options.roles.dev.go.enable = mkEnableOption "go language";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      go_1_11
      golint
      gocode
      gotags
      glide
      vimPlugins.vim-go
      dep
      dep2nix
      go2nix
      gotools
      go-protobuf

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "go";
          publisher = "ms-vscode";
          version = "0.8.0";
          sha256 = "0q7hf2b0zwn39kc11qny8vaqanvdci3m87nxqafdifm7rjmg4mjf";
        };
      })
    ];

    environment.variables = {
      GOPATH = ["$HOME/projects/go"];
    };
  };
}
