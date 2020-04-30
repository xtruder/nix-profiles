# sway wayland environments

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.wayland.windowManager.sway;
  modifier = cfg.config.modifier;

  runInEnvironment = pkgs.writeScript "sway-run-environment.sh" ''
    #!${pkgs.runtimeShell} -xe

    PATH=/run/wrappers/bin:${with pkgs; makeBinPath [ sway jq gnugrep bemenu coreutils ]}:$PATH

    workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).name | split(":") | .[1]' -r)

    if cat ~/.environments | grep -q "$workspace"; then
      env="$workspace"
    else
      env=$(cat ~/.environments | bemenu -l 10)
    fi

    if [ -z "$env" ]; then
      echo "no env selected"
      exit 0
    fi

    sudo -u $env sh -c "echo -e '$@\r\n0\r\n' | socat  - /run/user/$(id -u $env)/sockproc"
  '';

  markWindows = pkgs.writeScript "sway-mark-windows.sh" ''
    #!${pkgs.runtimeShell}

    PATH=${with pkgs; makeBinPath [ sway procps jq ]}:$PATH

    while true; do
      while IFS=$'\t' read -r id pid marks; do
        user=$(ps -o user= -p "$pid")
        mark="$id:$user"

        if ! [[ "$marks" == *"$mark"* ]]; then
          echo "marking $id $pid with $mark"

          if [ ! -z "$user" ]; then
            swaymsg "[con_id=$id] mark --add $mark"
          fi
        fi
      done < <(swaymsg -t get_tree | jq -r ".. | (.nodes? // empty)[] | select (.pid) | [.id, .pid, (.marks | join(\",\"))] | @tsv")
      sleep 2
    done
  '';

in {
  config = {
    wayland.windowManager.sway.config.keybindings = {
      # run command in environment
      "${modifier}+shift+d" = "exec ${runInEnvironment} 'exec $(${pkgs.dmenu}/bin/dmenu_path | ${pkgs.bemenu}/bin/bemenu -l 10)'";

      # run x11 command in environment
      "${modifier}+shift+x" = "exec ${runInEnvironment} 'GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb ${pkgs.cage}/bin/cage $(${pkgs.dmenu}/bin/dmenu_path | ${pkgs.bemenu}/bin/bemenu -l 10)'";

      # run terminal in environment
      "${modifier}+shift+Return" = "exec ${runInEnvironment} 'exec $TERMINAL'";
    };

    systemd.user.services.sway-mark-windows = {
      Unit = {
        Description = "Sway mark windows with id and user";
        After = [ "sway-session.traget" ];
      };

      Service = {
        ExecStart = toString markWindows;
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
