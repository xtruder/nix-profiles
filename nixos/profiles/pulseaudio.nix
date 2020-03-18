{ config, pkgs, ... }:

{
  config = {
    # enable pulseaudio with full pulseaudio support
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
