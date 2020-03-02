{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    programs.i3status = {
      enable = true;

      order = mkMerge [
        [
          (mkOrder 500 "online_status")
          (mkOrder 510 "disk /")
          (mkOrder 520 "load")
          (mkOrder 530 "net_rate")
          (mkOrder 540 "volume master")
        ]
        (mkIf config.attributes.hardware.hasBattery [
          (mkOrder 511 "battery 0")
          (mkOrder 550 "tztime local")
          (mkOrder 551 "tztime pst")
        ])
      ];

      blocks = mkMerge [{
        general.opts = {
          output_format = "i3bar";
          colors = true;
          interval = 5;
        };

        net_rate.opts = {
          interfaces = "ens3,ens4,wlan0,eth0";
          all_interfaces = false;
          si_units = true;
        };

        load.opts = {
          format = "↺ %1min";
        };

        disk_root = {
          type = "disk";
          name = "/";
          opts = {
            format = "√ %free";
          };
        };

        volume_master = {
          type = "volume";
          name = "master";
          opts = {
            format = "♪ %volume";
            device = "default";
            mixer = "Master";
            mixer_idx = 0;
          };
        };

        online = {};
      } (mkIf config.attributes.hardware.hasBattery {
        battery_0 = {
          type = "battery";
          name = "0";
          opts = {
            format = "%status %percentage %remaining";
            low_threshold = 10;
            last_full_capacity = true;
          };
        };

        tztime_local = {
          type = "tztime";
          name = "local";
          opts.format = "%Y-%m-%d ⌚ %H:%M:%S";
        };

        tztime_pst = {
          type = "tztime";
          name = "pst";

          opts = {
            format = "PST⌚ %H:%M";
            timezone = "America/Los_Angeles";
          };
        };
      })];
    };
  };
}
