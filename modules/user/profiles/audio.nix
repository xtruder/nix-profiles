{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.pulseaudio;
in {
  options.profiles.pulseaudio = {
    enable = mkEnableOption "pulseaudio";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.pavucontrol ];
    services.pasystray.enable = mkDefault config.xsession.enable;
  };
}
