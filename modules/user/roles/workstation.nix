{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.workstation.enable = mkEnableOption "workstation role";

  config = mkIf config.roles.workstation.enable {
    profiles = {
      i3.enable = true;
      pulseaudio.enable = true; 
      udisks.enable = true;
      dunst.enable = true;
      network-manager.enable = true;
      vim.enable = true;
      redshift.enable = true;
      xterm.enable = true;
    };

    themes.numix-solarized.enable = true;
  };
}
