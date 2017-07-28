{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.python;
in {
  options.roles.dev.python.enable = mkEnableOption "python development";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.python2Full.withPackages (ps: with ps; [
        virtualenv pip
      ]))
    ];
  };
}
