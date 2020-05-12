{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    programs.i3status = {
      enable = true;
      enableDefault = false;

      general = {
        output_format = "i3bar";
        colors = true;
        interval = 5;
      };

      modules = {
        "online_status" = {
          position = 1;
        };

        load = {
          position = 2;
          settings = {
            format = "↺ %1min";
          };
        };

        net_rate = {
          position = 3;
          settings = {
            interfaces = "ens3,ens4,wlan0,eth0";
            all_interfaces = false;
            si_units = true;
          };
        };

        "volume master" = {
          position = 5;
          settings = {
            format = "♪ %volume";
            device = "default";
            mixer = "Master";
            mixer_idx = 0;
          };
        };

        "battery all" = {
          position = 6;
          settings = {
            format = "%status %percentage %remaining";
            low_threshold = 10;
            last_full_capacity = true;
          };
        };

        "tztime local" = {
          position = 7;
          settings = {
            format = "%Y-%m-%d ⌚ %H:%M:%S";
          };
        };

        "tztime pst" = {
          position = 8;
          settings = {
            format = "PST⌚ %H:%M";
            timezone = "America/Los_Angeles";
          };
        };
      };
    };
  };
}
