{ config, lib, ... }:

with lib;

{
  services.code-server = {
    enable = true;
    extensions = mkDefault config.programs.vscode.extensions;
    userSettings = mkDefault config.programs.vscode.userSettings;
  };
}
