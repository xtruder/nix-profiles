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

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "go";
          publisher = "ms-vscode";
          version = "0.6.83";
          sha256 = "1gkgpml1x6b5xr4qgp77b44nv8gfzsbd2cb5hlbh14b7n36sh8xh";
        };
      })
    ];

    environment.variables = {
      GOPATH = ["$HOME/projects/go"];
    };
  };
}
