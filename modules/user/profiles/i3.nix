{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.i3;
  modifier = "Mod4";

  renameWorkspace = pkgs.writeScript "i3-rename-workspace.sh" ''
	#!${pkgs.bash}/bin/bash
    PATH=$PATH:${pkgs.jq}/bin:${pkgs.i3}/bin

	set -e

	num=`i3-msg -t get_workspaces | jq 'map(select(.focused == true))[0].num'`
	i3-input -F "rename workspace to \"$num:%s\"" -P 'New name: '

	name=`i3-msg -t get_workspaces | jq 'map(select(.focused == true))[0].name'`
	# If empty name was set
	if [[ "$name" =~ ^\"[0-9]+:\"$ ]]
	then
	  # Remove trailing colon and whitespace
	  i3-msg "rename workspace to \"$num\""
	fi
  '';

  monitorSelect = pkgs.writeScript "xrandr-change.sh" ''
    #!${pkgs.stdenv.shell}

    export PATH="${with pkgs; makeBinPath [xorg.xrandr findutils rofi coreutils pythonPackages.python gnugrep]}"

    set -e

    state="$(xrandr)";
    outputs="$(awk '{if ($2 == "connected") print $1}' <<< "$state")"

    function getModes() {
        awk -v output=$1 '{if ($1 == output) {getline; while ($0 ~ /^\ \ /) {print $1; getline;}}}' <<< "$state"
    }

    function getMode() {
        echo "$((echo auto; getModes "$1";) | rofi -dmenu -p "Select mode for $1 output")"
    }

    function getPosition() {
        output="$1"
        relationTo="$2"
        echo "$((echo -e "$output same-as $relationTo\n$output left-of $relationTo\n$output right-of $relationTo\n$output above $relationTo\n$output below $relationTo";) | rofi -dmenu -p "Select $output output relation to $relationTo output")"
    }

    function permutations() {
        python -c "import sys, itertools; a=sys.argv[1:]; print('\n'.join('\n'.join(' '.join(str(i) for i in c) for c in itertools.permutations(a, i)) for i in range(1, len(a)+1)))" "$@";
    }

    entries="$(permutations $outputs | rofi -dmenu -p "Select output combination (first one is primary)" | tr ' ' '\n')"

    flags=""
    primary="$(head -n 1 <<< "$entries")"

    if [[ -z "$entries" ]]
    then
        echo "No Selection" >&2
        exit 1
    fi

    for output in $outputs
    do
        if echo "$entries" | grep -Eq "^''${output}$"
        then
            mode="$(getMode $output)"
            if [ "$mode" == "auto" ] || [ -z "$mode" ]
            then
                modeFlag="--auto"
            else
                modeFlag="--mode $mode"
            fi

            if [ "$primary" == "$output" ]
            then
                flags="$flags --output $output --primary $modeFlag"
            else
                positionFlag="$(getPosition $output $primary | awk '{printf "--"$2" "$3}')"
                flags="$flags --output $output $modeFlag $positionFlag"
            fi
        else
            flags="$flags --output $output --off"
        fi
    done

    xrandr $flags
  '';

  reclassAppWindow = pkgs.writeScript "reclass-app-window.sh" ''
    #!${pkgs.stdenv.shell}

    new_class=$1
    shift

    $@ &
    pid="$!"

    trap 'kill -TERM $pid; wait $pid' TERM INT

    # Wait for the window to open and grab its window ID
    winid=""
    while : ; do
      ps --pid $pid &>/dev/null || exit 1
      winid="`${pkgs.wmctrl}/bin/wmctrl -lp | ${pkgs.gawk}/bin/awk -vpid=$pid '$3==pid {print $1; exit}'`"
      [[ -z "$winid"  ]] || break
    done

    ${pkgs.xdotool}/bin/xdotool set_window --class $new_class $winid

    wait $pid
  '';

  exposeWorkspace = pkgs.writeScript "i3-expose-workspace.sh" ''
    #!${pkgs.stdenv.shell}
    export WORKSPACE=''${WORKSPACE:-$(i3-msg -t get_workspaces  | ${pkgs.jq}/bin/jq '.[] | select(.focused==true).name | split(":") | .[1]' -r)}

    if [ "$WORKSPACE" == "null" ]; then
      unset WORKSPACE
    fi

    exec $@
  '';
in {
  options.profiles.i3 = {
    enable = mkEnableOption "i3";

    extraBarConfig = mkOption {
      description = "Extra bar configuration";
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    profiles.xsession.enable = mkDefault true;

    xsession.windowManager.i3 = {
      enable = true;

      extraConfig = ''
        # > horizontal | vertical | auto
        default_orientation horizontal
      '';

      config = {
        inherit modifier;

        # > default | stacking | tabbed
        workspaceLayout = "tabbed";

        floating = {
          inherit modifier;
          titlebar = false;
          border = 1;
        };

        window = {
          titlebar = false;
          border = 1;
          commands = [
            # rambox to scratchpad
            {
              criteria.instance = "rambox";
              command = "move window to scratchpad";
            }

            # enable floating for pop-up windows
            {
              criteria.window_role = "pop-up";
              command = "floating enable";
            }

            # move ffscratch to scratchpad
            {
              criteria.class = "ffscratch";
              command = "floating enable, resize set 1600 900, move window to scratchpad";
            }

            # move scratchterm to scratchpad
            {
              criteria.class = "scratchterm";
              command = "floating enable, resize set 1600 900, move window to scratchpad";
            }
          ];
          hideEdgeBorders = "smart";
        };

        startup = [(mkIf config.profiles.firefox.enable {
          command = "${reclassAppWindow} ffscratch firefox -P scratchpad ${toString config.profiles.firefox.startup.pages}";
          notification = false;
        }) {
          command = "env WORKSPACE=scratch ${reclassAppWindow} scratchterm i3-sensible-terminal";
          notification = false;
        }];

        keybindings = mkOptionDefault {
          "${modifier}+Return" = "exec ${exposeWorkspace} i3-sensible-terminal";

          # workspace selection
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 0";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          # rename workspace
          "${modifier}+n" = "exec ${renameWorkspace}";

          # monitor select
          "${modifier}+m" = "exec ${monitorSelect}";

          # move workspace to output
          "${modifier}+Control+Left" = "move workspace to output left";
          "${modifier}+Control+Down" = "move workspace to output down";
          "${modifier}+Control+Up" = "move workspace to output up";
          "${modifier}+Control+Right" = "move workspace to output right";

          # set sticky on window
          "${modifier}+Shift+s" = "sticky toggle";

          # start rofi (a program launcher)
          "${modifier}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -combi-modi drun -show combi -modi combi";

          # start passmenu
          "${modifier}+p" = "exec --no-startup-id ${pkgs.rofi-pass}/bin/rofi-pass";

          # print screen
          "Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -z -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f'";

          # print screen select a portion of window
          "${modifier}+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -zs -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f'";

          # Move the currently focused window to scratchpad
          "${modifier}+Shift+BackSpace" = "move scratchpad";

          # Show the first scratchpad window
          "${modifier}+BackSpace" = "scratchpad show, move position center";

          # Show scratchpad terminal
          "${modifier}+t" = ''[class="scratchterm"] scratchpad show, move position center'';

          # Show scratchpad browser
          "${modifier}+b" = ''[class="ffscratch"] scratchpad show, move position center'';

          # Volume control
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%+ && killall -SIGUSR1 i3status";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%- && killall -SIGUSR1 i3status";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 1+ toggle && killall -SIGUSR1 i3status";

          # Screen brightness controls
          "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 20";
          "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 20";

          # lock
          "${modifier}+l" = mkIf config.services.screen-locker.enable "exec ${pkgs.systemd}/bin/loginctl lock-session $XDG_SESSION_ID";

          # toggle synaptics touchpad
          "XF86TouchpadToggle" = "exec --no-startup-id ${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient TouchpadOff=$(${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient -l | grep -c 'TouchpadOff.*=.*0')";
        };

        bars = [(mkMerge [{
          statusCommand = "${pkgs.pythonPackages.py3status}/bin/py3status -c ~/.config/i3status/config";
        } cfg.extraBarConfig])];
      };
    };

    programs.rofi.enable = true;

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

    programs.i3lock.enable = true;
  };
}
