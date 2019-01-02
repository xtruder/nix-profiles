{ config, pkgs, lib, ...  }:

with lib;

let
  cfg = config.profiles.terminal;
in {
  options.profiles.terminal = {
    command = mkOption {
      description = "Terminal command";
      type = types.str;
      internal = true;
    };

    run = mkOption {
      description = "Command to run to start terminal";
      type = types.str;
      default = "$SHELL";
    };

    term = mkOption {
      description = "TERM to set";
      type = types.str;
      default = "secreen-256color";
    };
  };
}
