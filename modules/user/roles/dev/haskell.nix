{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.haskell;
in {
  options.roles.dev.haskell.enable = mkEnableOption "haskell language role";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      stack
    ];
  };
}
