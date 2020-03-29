{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.xsession.windowManager.i3;
  modifier = "Mod4";

  # renames current workspace
  renameWorkspace = pkgs.writeScript "i3-rename-workspace.sh" ''
	  #!${pkgs.runtimeShell} -el
    PATH=${with pkgs; makeBinPath [ jq i3 ]}

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

  # exposes name of the workspace via environment variable
  exposeWorkspace = pkgs.writeScript "i3-expose-workspace.sh" ''
    #!${pkgs.runtimeShell} -el
    PATH=${with pkgs; makeBinPath [ jq i3 ]}:$PATH

    export WORKSPACE=''${WORKSPACE:-$(i3-msg -t get_workspaces  | jq '.[] | select(.focused==true).name | split(":") | .[1]' -r)}

    if [ "$WORKSPACE" == "null" ]; then
      unset WORKSPACE
    fi

    exec $@
  '';

  # changes the class of the window
  reclassAppWindow = pkgs.writeScript "reclass-app-window.sh" ''
    #!${pkgs.runtimeShell} -el
    PATH=${with pkgs; makeBinPath [ wmctrl gawk xdotool ]}:$PATH

    new_class=$1
    shift

    $@ &
    pid="$!"

    trap 'kill -TERM $pid; wait $pid' TERM INT

    # Wait for the window to open and grab its window ID
    winid=""
    while : ; do
      ps --pid $pid &>/dev/null || exit 1
      winid="`wmctrl -lp | awk -vpid=$pid '$3==pid {print $1; exit}'`"
      [[ -z "$winid"  ]] || break
    done

    xdotool set_window --class $new_class $winid

    wait $pid
  '';

in {
  config = {
    home.packages = with pkgs; [ file ];

    xsession.windowManager.i3 = {
      enable = true;

      defaultBarConfig.statusCommand = mkDefault
        "${pkgs.pythonPackages.py3status}/bin/py3status -c ~/.config/i3status/config";

      config = {
        inherit modifier;

        workspaceLayout = "tabbed";
        defaultOrientation = "horizontal";

        floating.modifier = modifier;
        window = {
          commands = [
            # enable floating for pop-up windows
            {
              criteria.window_role = "pop-up";
              command = "floating enable";
            }
          ];
        };

        keybindings = mkOptionDefault {
          "${modifier}+Return" = "exec ${exposeWorkspace} i3-sensible-terminal";
          "${modifier}+Shift+q" = "kill";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+a" = "focus parent";

          # Move the currently focused window to scratchpad
          "${modifier}+Shift+BackSpace" = "move scratchpad";

          # Show the first scratchpad window
          "${modifier}+BackSpace" = "scratchpad show, move position center";

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

          # keybindings for moving windows to different workspaces
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          # reload/restart/exit i3
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          # resize mode for windows
          "${modifier}+r" = "mode resize";

          # rename workspace
          "${modifier}+n" = "exec ${renameWorkspace}";

          # set sticky on window
          "${modifier}+Shift+s" = "sticky toggle";

          # start rofi (a program launcher) if enabled, else run dmenu
          "${modifier}+d" =
            if config.programs.rofi.enable
            then "exec ${pkgs.rofi}/bin/rofi -combi-modi drun -show combi -modi combi"
            else "exec ${pkgs.dmenu}/bin/dmenu_run";

          # print screen
          "Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -z -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f'";

          # print screen select a portion of window
          "${modifier}+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -zs -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f'";

          # Show scratchpad terminal
          "${modifier}+t" = ''[class="scratchterm"] scratchpad show, move position center'';

          # Show scratchpad browser
          "${modifier}+b" = ''[class="scratchbrowser"] scratchpad show, move position center'';

          # Volume control
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%+ && killall -SIGUSR1 i3status";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%- && killall -SIGUSR1 i3status";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 1+ toggle && killall -SIGUSR1 i3status";

          # Music controls, uses playerctl that implements MPRIS D-Bus interface
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

          # Screen brightness controls
          "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 20";
          "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 20";

          # lock
          "${modifier}+l" = mkIf config.services.screen-locker.enable "exec ${pkgs.systemd}/bin/loginctl lock-session $XDG_SESSION_ID";

          # kill
          "${modifier}+k" = "exec '${pkgs.xorg.xkill}/bin/xkill'";

          # toggle synaptics touchpad
          "XF86TouchpadToggle" = "exec --no-startup-id ${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient TouchpadOff=$(${pkgs.xorg.xf86inputsynaptics.out}/bin/synclient -l | grep -c 'TouchpadOff.*=.*0')";
        };
      };
    };
  };
}
