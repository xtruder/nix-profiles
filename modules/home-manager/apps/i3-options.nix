{ config, lib, ... }:

with lib;

let
  cfg = config.xsession.windowManager.i3;

in {
  # add additional options for i3
  options.xsession.windowManager.i3 = {
    backgroundImage = mkOption {
      description = "Background image";
      type = types.nullOr types.path;
      default = null;
    };

    defaultBarConfig = mkOption {
      description = "Configuration for default i3 bar";
      type = types.attrs;
      default = {};
    };
  };

  config.xsession.windowManager.i3.config.bars = [ cfg.defaultBarConfig ];
}
