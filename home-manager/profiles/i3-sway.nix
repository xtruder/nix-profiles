{ config, cfg, lib, pkgs, i3-sway-scripts ? pkgs.i3-sway-scripts, ... }:

with lib;

let
  modifier = cfg.config.modifier;
in {
  config = {
    modifier = mkDefault "Mod4";

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

    keybindings = {
      # rename workspace
      "${modifier}+n" = "exec ${i3-sway-scripts}/bin/i3-rename-workspace";

      # run terminal
      "${modifier}+Return" = "exec ${i3-sway-scripts}/bin/i3-expose-workspace ${config.programs.terminal.terminalScript}";

      # kill current app
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
      "${modifier}+Shift+e" = mkDefault "exit";

      # resize mode for windows
      "${modifier}+r" = "mode resize";

      # set sticky on window
      "${modifier}+Shift+s" = "sticky toggle";

      # Volume control
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%+ && killall -SIGUSR1 i3status";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 5%- && killall -SIGUSR1 i3status";
      "XF86AudioMute" = "exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set Master 1+ toggle && killall -SIGUSR1 i3status";

      # Music controls, uses playerctl that implements MPRIS D-Bus interface
      "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
      "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
      "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

      # Screen brightness controls
      "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 20";
      "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 20";

      # lock
      "${modifier}+l" = "exec ${pkgs.systemd}/bin/loginctl lock-session $XDG_SESSION_ID";
    };
  };

  extraConfig = ''
    set $mode_system (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (S) shutdown

    mode "$mode_system" {
      bindsym l exec ${pkgs.systemd}/bin/loginctl lock-session $XDG_SESSION_ID, mode "default"
      bindsym e exit
      bindsym s exec --no-startup-id ${pkgs.systemd}/bin/systemctl suspend, mode "default"
      bindsym h exec --no-startup-id ${pkgs.systemd}/bin/systemctl hibernate, mode "default"
      bindsym r exec --no-startup-id ${pkgs.systemd}/bin/systemctl reboot, mode "default"
      bindsym Shift+s exec --no-startup-id ${pkgs.systemd}/bin/systemctl poweroff -i, mode "default"

      # back to normal: Enter or Escape
      bindsym Return mode "default"
      bindsym Escape mode "default"
      bindsym q mode "default"
    }

    bindsym ${modifier}+Shift+l mode "$mode_system"
  '';
}
