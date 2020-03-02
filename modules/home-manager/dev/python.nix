{ config, pkgs, lib, ... }:

with lib;

{
  config = {
    programs.vscode.extensions = [
      pkgs.vscode-extensions.ms-python.python
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ python-mode ];

    home.packages = with pkgs; [
      (python3Full.withPackages (ps: with ps; [
        virtualenv pip
      ]))
      pypi2nix
    ];
  };
}
