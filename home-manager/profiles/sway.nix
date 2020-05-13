{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.wayland.windowManager.sway;
  modifier = cfg.config.modifier;

  i3-sway-scripts = pkgs.i3-sway-scripts.override {
    useSway = true;
    promptCmd = prompt: ''${pkgs.rofi}/bin/rofi -dmenu -P "${prompt}" -lines 0'';
  };
  i3-sway = import ./i3-sway.nix { inherit config cfg lib pkgs i3-sway-scripts; };

  systemctl = "${pkgs.systemd}/bin/systemctl";

  importedVariables = [
    "DBUS_SESSION_BUS_ADDRESS"
    "DISPLAY"
    "WAYLAND_DISPLAY"
    "SSH_AUTH_SOCK"
    "XAUTHORITY"
    "XDG_DATA_DIRS"
    "XDG_RUNTIME_DIR"
    "XDG_SESSION_ID"
  ];

in {
  config = {
    wayland.windowManager.sway = mkMerge [i3-sway {
      enable = true;

      systemdIntegration = false;

      extraSessionCommands = ''
        export GIO_EXTRA_MODULES=${pkgs.dconf.lib}/lib/gio/modules

        ${systemctl} --user import-environment ${toString importedVariables}
      '';

      config.keybindings = {
        # print screen
        "Print" = ''exec --no-startup-id ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy'';

        # print screen select a portion of window
        "${modifier}+Print" = ''exec --no-startup-id ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
      };

      config.startup = [{
        command = "${systemctl} start --user graphical-session.target";
      }];
    }];
  };
}
