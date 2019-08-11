{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.xterm;
in {
  options.profiles.xterm = {
    enable = mkEnableOption "xterm terminal";
  };

  config = mkIf cfg.enable {
    profiles.terminal.command = "xterm -e ";

    xresources.properties = {
      "XTerm*eightBitInput" = false;
      "XTerm*faceSize" = 10;
      "XTerm*dynamicColors" = true;
      "XTerm*metaSendsEscape" = true;
      "XTerm*selectToClipboard" = true;
    };
  };
}
