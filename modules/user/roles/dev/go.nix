{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.go;
in {
  options.roles.dev.go.enable = mkEnableOption "go language role";

  config = mkIf cfg.enable {
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

    programs.vscode.extensions = [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "go";
          publisher = "ms-vscode";
          version = "0.9.0";
          sha256 = "06mv867f3jnr9vzzyqjgji7426nzrqjf15ad8crirjc84cqhhmvi";
        };
      })
    ];

    home.sessionVariables = {
      GOPATH = "$HOME/projects/go";
    };
  };
}
