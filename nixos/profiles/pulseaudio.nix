{ config, pkgs, ... }:

{
  config = {
    # enable pulseaudio with full pulseaudio support
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
        load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
      '';
      support32Bit = true;
    };
  };
}
