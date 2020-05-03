{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.wayland.windowManager.sway;
  modifier = cfg.config.modifier;

  i3-sway-scripts = pkgs.i3-sway-scripts.override {
    useSway = true;
    promptCmd = prompt: ''${pkgs.rofi}/bin/rofi -dmenu -P "${prompt}" -lines 0'';
  };
  i3-sway = import ./i3-sway.nix { inherit config lib pkgs i3-sway-scripts; };

in {
  config = {
    wayland.windowManager.sway = mkMerge [i3-sway {
      enable = true;

      systemdIntegration = false;

      config.keybindings = {
        # print screen
        "Print" = ''exec --no-startup-id ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy'';

        # print screen select a portion of window
        "${modifier}+Print" = ''exec --no-startup-id ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
      };
    }];
  };
}
