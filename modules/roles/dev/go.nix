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
          version = "0.6.90";
          sha256 = "00l6mh97k7smy3dnj6dn6qlssjdzfna9nd6h4d7y31830n1mm13l";
        };
      })
    ];

    environment.variables = {
      GOPATH = ["$HOME/projects/go"];
    };
  };
}
