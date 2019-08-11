{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.python;
in {
  options.roles.dev.python.enable = mkEnableOption "python development";

  config = mkIf cfg.enable {
    profiles.vscode.extensions = [
      pkgs.vscode-extensions.ms-python.python
    ];

    environment.systemPackages = with pkgs; [
      (python3Full.withPackages (ps: with ps; [
        virtualenv pip
      ]))
    ];
  };
}
