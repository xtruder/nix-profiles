{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.pulseaudio.enable = mkEnableOption "pulseaudio";

  config = mkIf config.profiles.pulseaudio.enable {
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
      support32Bit = true;
    };
  };
}
