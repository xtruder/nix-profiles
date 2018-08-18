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
    ];

    environment.variables = {
      GOPATH = ["$HOME/projects/go"];
    };
  };
}
