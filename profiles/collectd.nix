{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.monitoring.collectd;
in {
  options.profiles.monitoring.collectd = {
    enable = mkOption {
      description = "Whether to enable collectd profile.";
      default = false;
      type = types.bool;
    };

    influxdbHost = mkOption {
      description = "Influxdb host";
      default = "localhost";
      type = types.str;
    };

    influxdbPort = mkOption {
      description = "Influxdb port";
      default = 25826;
      type = types.int;
    };
  };

  config = mkIf (cfg.enable) {
    services.collectd = {
      enable = mkDefault true;
      user = "root"; # some commands are privileged
      extraConfig = ''
        LoadPlugin network
        LoadPlugin ping
        LoadPlugin df
        LoadPlugin memory
        LoadPlugin load
        LoadPlugin cpu
        LoadPlugin interface
        LoadPlugin uptime
        LoadPlugin swap

        <Plugin ping>
          Host "localhost"
        </Plugin>

        <Plugin "network">
          Server "${cfg.influxdbHost}" "${toString cfg.influxdbPort}"
        </Plugin>

        <Plugin "df">
          IgnoreSelected true
          ReportInodes true
          ReportByDevice true
        </Plugin>

        <Plugin interface>
          Interface "eth0"
          IgnoreSelected false
        </Plugin>

        <Plugin "uptime">
        </Plugin>

        <Plugin "memory">
        </Plugin>

        <Plugin "swap">
        </Plugin>
      '';
    };

  };
}
