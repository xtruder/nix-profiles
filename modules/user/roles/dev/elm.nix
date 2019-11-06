{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.elm;
in {
  options.roles.dev.elm.enable = mkEnableOption "elm role";

  config = mkIf cfg.enable {
    roles.dev.node.enable = mkDefault true;

    programs.vscode.extensions = [
      pkgs.vscode-extensions'.elm
      pkgs.vscode-extensions'.vscode-elm-jump
    ];

    home.packages = with pkgs; [
      elmPackages.elm
    ];
  };
}
