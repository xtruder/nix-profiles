{ config, pkgs, lib, ... }:

with lib;

{
  options.profiles.st = {
    enable = mkEnableOption "suckless terminal";
  };

  config = {
    nixpkgs.config.st ={
      patches = [
        ./st-alpha-20160727-308bfbf.diff
        ./st-solarized-both-20160727-308bfbf.diff
      ];

      conf = builtins.readFile ./st.conf;
    };

    profiles.terminal.command = ''st -c "sucklessterm" -e '';

    environment.systemPackages = [pkgs.st];
  };
}
