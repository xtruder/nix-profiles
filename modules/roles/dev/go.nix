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
      vgo2nix
      gotools
      go-protobuf
    ];

    profiles.vscode.extensions = [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "go";
          publisher = "ms-vscode";
          version = "0.9.0";
          sha256 = "06mv867f3jnr9vzzyqjgji7426nzrqjf15ad8crirjc84cqhhmvi";
        };
      })
    ];

    environment.variables = {
      GOPATH = ["$HOME/projects/go"];
    };
  };
}
