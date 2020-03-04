{ config, pkgs, ... }:

{
  config = {
    programs.vscode = {
      enable = true;
      userSettings = {
        "window.zoomLevel" = 0;
        "terminal.integrated.rendererType" = "dom";
        "terminal.integrated.shell.linux" = "/run/current-system/sw/bin/bash";
        "breadcrumbs.enabled" = true;
      };
      extensions = with pkgs.my-vscode-extensions; [
        vim
        path-autocomplete
        all-autocomplete
      ];
    };
  };
}
