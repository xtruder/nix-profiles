{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.st;
in {
  options.profiles.st = {
    enable = mkEnableOption "suckless terminal";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.st ={
      patches = [
        ./st-solarized-both-0.8.1.diff
      ];

      conf = builtins.readFile ./st.conf;
    };

    profiles.terminal.command = ''st -c "sucklessterm" -e '';

    environment.systemPackages = [pkgs.st];
  };
}
