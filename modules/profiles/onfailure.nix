{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.monitoring.onfailure;
in {
  options.profiles.monitoring.onfailure = {
    enable = mkOption {
      description = "Whether to enable monitoring.";
      default = false;
    };

    services = mkOption {
      description = "List of services to monitor.";
      type = types.listOf types.str;
      default = [];
    };

    command = mkOption {
      description = "Command to execute on failure.";
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.services."onfailure@" = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = cfg.command;
        };
      };
    }
    {
      systemd.services = mkMerge (map (name: {
        ${name}.onFailure = ["onfailure@${name}.service"];
      }) cfg.services);
    }
  ]);
}
