{ config, pkgs, ... }:

let
  modifier = config.xsession.windowManager.i3.config.modifier;

in {
  home.file.".config/rofi-pass/config".text = ''
    _pwgen() {
      pwgen -y "$@" 1
    }
  '';

  xsession.windowManager.i3.config.keybindings = {
    # start passmenu
    "${modifier}+p" = "exec --no-startup-id ${pkgs.rofi-pass}/bin/rofi-pass";
  };

  home.packages = [ pkgs.rofi-pass ];
}
