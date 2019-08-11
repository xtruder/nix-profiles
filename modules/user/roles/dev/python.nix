{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.python;
in {
  options.roles.dev.python.enable = mkEnableOption "python dev role";

  config = mkIf cfg.enable {
    programs.vscode.extensions = [
      pkgs.vscode-extensions.ms-python.python
    ];

    programs.vim.plugins = [ "python-mode" ];

    home.packages = with pkgs; [
      (python3Full.withPackages (ps: with ps; [
        virtualenv pip
      ]))
      pypi2nix
    ];
  };
}
