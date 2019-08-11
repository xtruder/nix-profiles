{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.xsuspender;
in {
  options.profiles.xsuspender = {
    enable = mkEnableOption "xsuspender";
  };

  config = mkIf config.profiles.xsuspender.enable {
    services.xsuspender = {
      enable = true;
      rules.Chromium = {
        suspendDelay = 10;
        matchWmClassContains = "chromium-browser";
        suspendSubtreePattern = "chromium";
      };
    };
  };
}
