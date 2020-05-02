# creates a sensible sway desktop setup

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.wayland.windowManager.sway;
  modifier = cfg.config.modifier;

  markAppWindow = pkgs.writeScript "mark-app-window.sh" ''
    #!${pkgs.stdenv.shell} -el
    PATH=${makeBinPath [ pkgs.jq pkgs.sway pkgs.procps ]}:$PATH

    mark=$1
    shift

    $@ &
    pid="$!"

    trap 'kill -TERM $pid; wait $pid' TERM INT

    pidtree() {
      for _pid in "$@"; do
        echo $_pid
        pidtree `ps --ppid $_pid -o pid h`
      done
    }

    # Wait for the window to open and grab its window ID
    con_id=""
    while : ; do
      # get child pids of process as commad separated
      pids=$(pidtree $pid | xargs | sed -e 's/ /, /g')

      # exit if process has quit
      [[ -z $pids ]] && exit 1

      # get all the windows
      con_ids=`swaymsg -t get_tree | jq -r ".. | (.nodes? // empty)[] | select(.pid == ($pids)) | .id"`

      # wait until window is found
      [[ -z "$con_ids"  ]] || break
    done

    # mark all windows
    for con_id in $con_ids; do
      swaymsg "[con_id=$con_id] mark --add $mark"
    done

    wait $pid
  '';

in {
  imports = [
    ./base.nix

    ../profiles/wayland.nix
    ../profiles/sway.nix
    ../profiles/swayidle.nix
    #../profiles/waybar.nix
    ../profiles/udiskie.nix
    ../profiles/dunst.nix
    ../profiles/kitty.nix
    ../profiles/rofi.nix
    ../profiles/gnome-keyring.nix
    ../profiles/redhsift.nix
    ../profiles/sway-wayland-environments.nix
  ];

  config = {
    services.network-manager-applet.enable = mkDefault true;
    services.pasystray.enable = mkDefault true;
    services.blueman-applet.enable = mkDefault true;
    services.gpg-agent.pinentryFlavor = "gnome3";

    xsession.preferStatusNotifierItems = true;
    wayland.windowManager.sway = {
      config = {
        bars = mkForce [];

        keybindings = {
          # Show scratchpad terminal
          "${modifier}+t" = ''[con_mark="scratchterm"] scratchpad show, move position center'';

          # Show scratchpad browser
          "${modifier}+b" = ''[con_mark="scratchbrowser"] scratchpad show, move position center'';
        };

        startup = [{
          command = "${markAppWindow} scratchbrowser firefox -P scratchpad";
        } {
          command = "env WORKSPACE=scratch ${markAppWindow} scratchterm ${config.programs.terminal.terminalScript}";
        }];
        window.commands = [
          # move windows with scratchbrowser mark to scratchpad and set to smaller size
          {
            criteria.con_mark = "scratchbrowser";
            command = "floating enable, resize set 3440 1876, move window to scratchpad";
          }

          # move windows with scratchterm mark to scratchpad and set to smaller size
          {
            criteria.con_mark = "scratchterm";
            command = "floating enable, resize set 3440 1876, move window to scratchpad";
          }

          {
            criteria = {
              app_id = "waybar";
              floating = "true";
            };
            command = "move position cursor, move down 120px";
          }
        ];
      };

      extraConfig = ''
        bar {
          swaybar_command ${pkgs.waybar}/bin/waybar
        }
      '';
    };
  };
}
