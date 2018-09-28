{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.i3;

  i3Lock = pkgs.writeScript "i3-lock.sh" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.scrot}/bin/scrot /tmp/screen_locked.png
    ${pkgs.imagemagick}/bin/convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked.png  
    ${pkgs.i3lock-color}/bin/i3lock-color 0 -i /tmp/screen_locked.png \
        --insidevercolor=ffffff22 \
        --insidewrongcolor=C6666655 \
        --insidecolor=ffffff22 \
        --ringvercolor=002b36ff \
        --ringwrongcolor=002b36ff \
        --ringcolor=002b36ff \
        --linecolor=1B465100 \
        --keyhlcolor=2AA198FF \
        --bshlcolor=2AA198FF
  '';

in {
  options.profiles.i3 = {
    enable = mkOption {
      description = "Whether to enable i3 profile.";
      default = false;
      type = types.bool;
    };

    primaryMonitor = mkOption {
      description = "Identifier of the primary monitor";
      type = types.str;
      default = "eDP1";
    };

    secondaryMonitor = mkOption {
      description = "Identifier of the secondary monitor";
      type = types.str;
      default = "HDMI1";
    };

    terminal = mkOption {
      description = "Command to start terminal";
      type = types.str;
      default = config.profiles.terminal.command;
    };

    background = mkOption {
      description = "Background image to use";
      type = types.package;
      default = pkgs.fetchurl {
        url = "https://i.redd.it/szkzdvg2lu5x.png";
        sha256 = "0lsrjsbwm5678an31282vp703gkzy1nin2l0v37g240zgxi3d5zq";
      };
    };

    screenLock.enable = mkOption {
      description = "Whether to enable screen locking";
      default = true;
      type = types.bool;
    };

    extraConfig = mkOption {
      description = "I3 extra config";
      type = types.lines;
      default = "";
    };

    extraBarConfig = mkOption {
      description = "Extra configuration for statusbar";
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    profiles.x11 = {
      enable = true;
      compositor = mkDefault false;
      displayManager = true;
      headless = mkDefault true;
    };

    environment.etc."i3/config".text = ''
      set $mon_lap ${cfg.primaryMonitor}
      set $mon_ext ${cfg.secondaryMonitor}

      # Set mod key
      set $mod Mod4

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      # > horizontal | vertical | auto
      default_orientation horizontal

      hide_edge_borders smart

      # > default | stacking | tabbed
      workspace_layout tabbed
      
      # cursor keys to switch windows:
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right

      # cursor keys to move windows:
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # split in horizontal orientation
      bindsym $mod+h split h

      # split in vertical orientation
      bindsym $mod+v split v

      # enter fullscreen mode for the focused container
      bindsym $mod+f fullscreen

      # change container layout (stacked, tabbed, toggle split)
      bindsym $mod+s layout stacking
      bindsym $mod+w layout tabbed
      bindsym $mod+e layout toggle split

      # toggle tiling / floating
      bindsym $mod+Shift+space floating toggle

      # change focus between tiling / floating windows
      bindsym $mod+space focus mode_toggle

      # focus the parent container
      bindsym $mod+a focus parent

      # focus the child container
      #bindsym $mod+d focus child

      # switch to workspace
      bindsym $mod+1 workspace number 1
      bindsym $mod+2 workspace number 2
      bindsym $mod+3 workspace number 3
      bindsym $mod+4 workspace number 4
      bindsym $mod+5 workspace number 5
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9
      bindsym $mod+0 workspace number 10

      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number 1
      bindsym $mod+Shift+2 move container to workspace number 2
      bindsym $mod+Shift+3 move container to workspace number 3
      bindsym $mod+Shift+4 move container to workspace number 4
      bindsym $mod+Shift+5 move container to workspace number 5
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9
      bindsym $mod+Shift+0 move container to workspace number 10

      # move workspace to output
      bindsym $mod+Control+Left move workspace to output left
      bindsym $mod+Control+Down move workspace to output down
      bindsym $mod+Control+Up move workspace to output up
      bindsym $mod+Control+Right move workspace to output right

      # set sticky on window
      bindsym $mod+Shift+s sticky toggle

      # reload the configuration file
      bindsym $mod+Shift+c reload

      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      bindsym $mod+Shift+r restart

      # exit i3 (logs you out of your X session)
      bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

      # resize window (you can also use the mouse for that)
      mode "resize" {
        # resize windows
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
      }

      bindsym $mod+r mode "resize"

      # start a terminal
      bindsym $mod+Return exec ${config.profiles.terminal.command} ${config.profiles.terminal.run} 

      # kill focused window
      bindsym $mod+Shift+q kill

      # start rofi (a program launcher)
      bindsym $mod+d exec --no-startup-id rofi -combi-modi drun -show combi -modi combi

      # Start passmenu
      bindsym $mod+p exec --no-startup-id rofi-pass

      # scrot
      bindsym Print exec --no-startup-id scrot -z -e 'xclip -selection clipboard -t image/png -i $f'

      # scrot select window or rectangle (Sys_Req is Print if holding Alt)
      bindsym Mod1+Sys_Req exec --no-startup-id scrot -zs -e 'xclip -selection clipboard -t image/png -i $f'

      # Monitor mode
      mode "monitor_select" {
        # only one
        bindsym 1 exec --no-startup-id xrandr --output $mon_ext --off; mode "default"

        # left and right
        bindsym l exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --left-of $mon_lap ; exec --no-startup-id systemctl --user restart compton ; mode "default"
        bindsym r exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --right-of $mon_lap ; exec --no-startup-id systemctl --user restart compton ; mode "default"

        # clone
        bindsym c exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --same-as $mon_lap ; mode "default"

        # presentation
        bindsym p exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --left-of $mon_lap ; mode "default"

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
      }

      bindsym $mod+m mode "monitor_select"

      # Start i3bar to display a workspace bar (plus the system information i3status
      # finds out, if available)
      bar {
          status_command ${pkgs.pythonPackages.py3status}/bin/py3status -c ${pkgs.writeText "i3status.conf" ''
            general {
              output_format = "i3bar"
              colors = true
              interval = 5
            }

            net_rate {
              interfaces = "ens3,ens4,wlan0,eth0"
              all_interfaces = false
              si_units = true
            }

            order += "online_status"
            order += "disk /"
            ${optionalString config.roles.laptop.enable ''order += "battery 0"''}
            order += "load"
            order += "net_rate"
            order += "volume master"
            ${optionalString (!config.roles.vm.enable) ''
            order += "tztime local"
            order += "tztime pst"
            ''}

            ${optionalString config.roles.laptop.enable ''
            battery 0 {
              format = "%status %percentage %remaining"
              low_threshold = 10
              last_full_capacity = true
            }
            ''}

            ${optionalString (!config.roles.vm.enable) ''
            tztime local {
              format = "%Y-%m-%d ⌚ %H:%M:%S"
            }

            tztime pst {
              format = "⌚ %H:%M"
              timezone = "America/Los_Angeles"
            }
            ''}

            load {
              format = "↺ %1min"
            }

            disk "/" {
              format = "√ %free"
            }

            volume master {
              format = "♪ %volume"
              device = "default"
              mixer = "Master"
              mixer_idx = 0
            }

            online_status {
            }

          ''}

          ${cfg.extraBarConfig}
      }

      for_window [window_role="pop-up"] floating enable

      # Make the currently focused window a scratchpad
      bindsym $mod+Ctrl+BackSpace move scratchpad

      # Show the first scratchpad window
      bindsym $mod+BackSpace scratchpad show

      # Volume controle
      bindsym XF86AudioRaiseVolume exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%+ && killall -SIGUSR1 i3status
      bindsym XF86AudioLowerVolume exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%- && killall -SIGUSR1 i3status
      bindsym XF86AudioMute exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 1+ toggle && killall -SIGUSR1 i3status

      # lock
      ${optionalString cfg.screenLock.enable ''
      bindsym $mod+l exec --no-startup-id ${i3Lock}
      ''}

      ${optionalString config.services.xserver.synaptics.enable ''
        bindsym XF86TouchpadToggle exec --no-startup-id ${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient TouchpadOff=$(${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient -l | grep -c 'TouchpadOff.*=.*0')
      ''}

      exec --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${cfg.background} 

      ${cfg.extraConfig} 
    '';

    services.xserver.windowManager.default = mkDefault "i3";
    services.xserver.windowManager.i3 = {
      enable = mkDefault true;
      configFile = "/etc/i3/config";
    };

    systemd.services.i3lock = {
      description = "Pre-Sleep i3 lock";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      environment.DISPLAY = ":0";
      serviceConfig.User = config.users.users.admin.name;  
      serviceConfig.ExecStart = i3Lock;
      serviceConfig.Type = "forking";
    };

    environment.systemPackages = with pkgs; [
      i3status acpi rofi rofi-pass st xterm scrot xclip
    ];
  };
}
