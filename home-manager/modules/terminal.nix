{ config, pkgs, lib, ...  }:

with lib;

let
  cfg = config.programs.terminal;

  terminalScript = pkgs.writeScript "term.sh" ''
    #!${pkgs.stdenv.shell}
    exec ${cfg.command} ${cfg.run} $@
  '';
in {
  options.programs.terminal = {
    command = mkOption {
      description = "Terminal command";
      type = types.nullOr types.str;
      default = null;
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

  config = mkIf (cfg.command != null) {
    home.sessionVariables.TERMINAL = toString terminalScriptu;
  };
}
