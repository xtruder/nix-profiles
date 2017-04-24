{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.node;
in {
  options.roles.dev.node.enable = mkEnableOption "node language";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs-7_x
      flow

      #vim-jsdoc
    ];

    programs.npm.enable = true;

    environment.variables = {
      PATH = ["$HOME/.npm/bin"];
    };
  };
}
