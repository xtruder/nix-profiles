{ config, lib, ... }:

with lib;

let
  cfg = config.wayland.windowManager.sway;

in {
  # add additional options for i3
  options.wayland.windowManager.sway = {
    defaultBarConfig = mkOption {
      description = "Configuration for default i3 bar";
      type = types.attrs;
      default = {};
    };
  };

  config = {
    wayland.windowManager.sway = {
      config.bars = [ cfg.defaultBarConfig ];
    };
  };
}
