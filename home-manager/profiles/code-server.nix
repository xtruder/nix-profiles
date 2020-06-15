{ config, lib, ... }:

with lib;

{
  services.code-server = {
    enable = true;
    extensions = mkDefault config.programs.vscode.extensions;
    userSettings = mkMerge [
      config.programs.vscode.userSettings
      {
        "terminal.integrated.shell.linux" = "/run/current-system/sw/bin/bash";
        "breadcrumbs.enabled" = true;
      }
    ];
  };
}
