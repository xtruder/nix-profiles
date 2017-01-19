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
        --ringvercolor=09343Fff \
        --ringwrongcolor=09343Fff \
        --ringcolor=262626ff \
        --textcolor=ffffffff \
        --linecolor=1B465100 \
        --keyhlcolor=1B4651ff \
        --bshlcolor=1B4651ff
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
      default = config.attributes.termCommand;
    };

    background = mkOption {
      description = "Background image to use";
      type = types.package;
      default = pkgs.fetchurl {
        url = "https://i.redd.it/szkzdvg2lu5x.png";
        sha256 = "0lsrjsbwm5678an31282vp703gkzy1nin2l0v37g240zgxi3d5zq";
      };
    };
  };

  config = mkIf cfg.enable {
    profiles.x11.enable = mkDefault true;

    services.xserver.windowManager.default = mkDefault "i3";
    services.xserver.windowManager.i3 = {
      enable = mkDefault true;
      extraSessionCommands = ''
        ${pkgs.feh}/bin/feh --bg-fill ${cfg.background}
        ${pkgs.dunst}/bin/dunst &
        ${optionalString config.networking.networkmanager.enable "${pkgs.networkmanagerapplet}/bin/nm-applet &"}
        ${optionalString config.hardware.bluetooth.enable "${pkgs.blueman}/bin/blueman-applet &"}
      '';
      configFile = pkgs.writeText "i3.cfg" ''
        set $mon_lap ${cfg.primaryMonitor}
        set $mon_ext ${cfg.secondaryMonitor}

        # Set mod key
        set $mod Mod4

        # The font above is very space-efficient, that is, it looks good, sharp and
        # clear in small sizes. However, if you need a lot of unicode glyphs or
        # right-to-left text rendering, you should instead use pango for rendering and
        # chose a FreeType font, such as:
        # font pango:DejaVu Sans Mono 8
        font pango:open Sans Mono 10

        # Use Mouse+$mod to drag floating windows to their wanted position
        floating_modifier $mod

        # > horizontal | vertical | auto
        default_orientation horizontal

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
        bindsym $mod+Return exec ${cfg.terminal}

        # kill focused window
        bindsym $mod+Shift+q kill

        # start rofi (a program launcher)
        bindsym $mod+d exec --no-startup-id ${pkgs.xpraenv}/bin/i3-run rofi -combi-modi drun -show combi -modi combi

        # start xpraenv
        bindsym $mod+n exec --no-startup-id ${pkgs.xpraenv}/bin/xpraenv

        # Start passmenu
        bindsym $mod+p exec --no-startup-id ${pkgs.xpraenv}/bin/i3-run rofi-pass

        # Monitor mode
        mode "monitor_select" {

          # only one
          bindsym 1 exec --no-startup-id xrandr --output $mon_ext --off; mode "default"

          # left and right
          bindsym l exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --left-of $mon_lap ; mode "default"
          bindsym r exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --right-of $mon_lap ; mode "default"

          # up and down
          bindsym u exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --above $mon_lap ; mode "default"
          bindsym d exec --no-startup-id xrandr --output $mon_lap --auto --output $mon_ext --auto --below $mon_lap ; mode "default"

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

              order += "online_status"
              order += "disk /"
              order += "battery 0"
              order += "load"
              order += "volume master"
              order += "tztime local"
              order += "tztime pst"

              battery 0 {
                      format = "%status %percentage %remaining"
                      low_threshold = 10
                      last_full_capacity = true
              }

              tztime local {
                      format = "%Y-%m-%d ⌚ %H:%M:%S"
              }
              tztime pst {
                      format = "⌚ %H:%M"
                      timezone = "America/Los_Angeles"
              }

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

            position bottom
            font pango:open Sans Mono 10

            colors {
                background #262626
                statusline #CCCCCC
                separator #CCCCCC

                focused_workspace  #167AC6 #167AC6 #CCCCCC
                active_workspace   #262626 #5f676a #dedede
                inactive_workspace #262626 #262626 #888888
                urgent_workspace   #333333 #900000 #ffffff
            }
        }

        for_window [window_role="pop-up"] floating enable

        # Make the currently focused window a scratchpad
        bindsym $mod+Ctrl+BackSpace move scratchpad

        # Show the first scratchpad window
        bindsym $mod+BackSpace scratchpad show

        hide_edge_borders both
        client.focused #167AC6 #167AC6 #CCCCCC #167AC6 #167AC6
        client.focused_inactive #262626 #262626 #ffffff #262626 #262626
        client.unfocused #262626 #262626 #ffffff #262626 #262626

        # Volume controle
        bindsym XF86AudioRaiseVolume exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%+ && killall -SIGUSR1 i3status
        bindsym XF86AudioLowerVolume exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%- && killall -SIGUSR1 i3status
        bindsym XF86AudioMute exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 1+ toggle && killall -SIGUSR1 i3status

        # lock
        bindsym $mod+l exec --no-startup-id ${i3Lock}

        ${optionalString config.services.xserver.synaptics.enable ''
          bindsym XF86TouchpadToggle exec --no-startup-id ${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient TouchpadOff=$(${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient -l | grep -c 'TouchpadOff.*=.*0')
        ''}
      '';
    };

    systemd.services."i3lock" =
      { description = "Pre-Sleep i3 lock";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        environment = {
          DISPLAY = ":0";
          USER = "offlinehacker";
          XAUTHORITY = "/home/offlinehacker/.Xauthority";
        };
        serviceConfig.ExecStart = i3Lock;
        serviceConfig.Type = "forking";
        serviceConfig.User = "offlinehacker";
      };

    environment.systemPackages = with pkgs; [i3status acpi xpraenv rofi rofi-pass i3 xterm];
  };
}
