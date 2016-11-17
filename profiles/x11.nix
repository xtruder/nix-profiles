{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.x11;
in {
  options.profiles.x11 = {
    enable = mkEnableOption "Whether to enable x11 server profile.";
  };

  config = mkIf cfg.enable {
    fonts.fonts = [ pkgs.cantarell_fonts pkgs.powerline-fonts pkgs.ttf_bitstream_vera ];

    services.compton.enable = true;
    services.compton.extraOptions = ''
      opacity-rule = [
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'",
        "80:class_g = 'i3bar' && !_NET_WM_STATE@:32a"
      ];
    '';

    services.xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;

      layout = "en";

      desktopManager.xterm.enable = false;
      displayManager.slim.enable = true;
    };

    environment.systemPackages = with pkgs; [ xorg.xauth xorg.xev xsel xfontsel ];

    environment.sessionVariables.LD_LIBRARY_PATH = mkForce [];
  };
}
