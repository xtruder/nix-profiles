# sway wayland environments

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.wayland.windowManager.sway;
  modifier = cfg.config.modifier;

  importedVariables = config.xsession.importedVariables ++ [
    "WAYLAND_DISPLAY"
  ];

  mountWaylandSock = pkgs.writeScript "mount-wayland-sock.sh" ''
    #!${pkgs.runtimeShell} -xe

    PATH=/run/wrappers/bin:/run/current-system/sw/bin

    while [ ! -d /run/user/$UID ]; do
      sleep 1
    done

    touch /run/user/$UID/$WAYLAND_DISPLAY /run/user/$UID/$WAYLAND_DISPLAY.lock

    if mountpoint -q /run/user/$UID/$WAYLAND_DISPLAY; then
      echo already mounted
    else
      mount -o bind /run/user/$HOST_UID/$WAYLAND_DISPLAY /run/user/$UID/$WAYLAND_DISPLAY
    fi

    if mountpoint -q /run/user/$UID/$WAYLAND_DISPLAY.lock; then
      echo already mounted
    else
      mount -o bind /run/user/$HOST_UID/$WAYLAND_DISPLAY.lock /run/user/$UID/$WAYLAND_DISPLAY.lock
    fi

    chmod g+rw /run/user/$UID/$WAYLAND_DISPLAY /run/user/$UID/$WAYLAND_DISPLAY.lock

    sleep 1

    sudo -u xtruder XDG_RUNTIME_DIR=/run/user/$UID bash -c "source ~/.profile && systemctl --user import-environment"
  '';

  prepareSession = pkgs.writeScript "prepare-session.sh" ''
    #!${pkgs.runtimeShell} -xe

    PATH=/run/wrappers/bin:/run/current-system/sw/bin
    export XDG_RUNTIME_DIR=/run/user/$UID

    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"

    if [ -e "$HOME/.profile" ]; then
      . "$HOME/.profile"
    fi

    systemctl --user import-environment ${toString (unique importedVariables)}

    export HM_XPROFILE_SOURCED=1

    tail -f /dev/null
  '';

  runInEnvironment = cmd: pkgs.writeScript "sway-run-environment.sh" ''
    #!${pkgs.runtimeShell} -xe

    PATH=/run/wrappers/bin:${with pkgs; makeBinPath [ sway jq gnugrep systemd bemenu coreutils ]}:$PATH

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

    if loginctl | grep $env; then
      echo "Env $env already exists"
    else
      sudo systemd-run \
        --property PAMName=login \
        --property User=$env \
        --property ExecStartPost=${mountWaylandSock} \
        --property PermissionsStartOnly=true \
        -E WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
        -E XDG_SESSION_TYPE=wayland \
        -E UID=$(id -u $env) \
        -E HOST_UID=$(id -u) \
        --uid=$env \
        ${prepareSession}

      sleep 1
    fi

    sudo -u $env XDG_RUNTIME_DIR=/run/user/$(id -u $env) systemd-run --user /run/current-system/sw/bin/bash -i -c 'source ~/.profile && ${cmd}'
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
      "${modifier}+shift+d" = "exec ${runInEnvironment "exec $(${pkgs.dmenu}/bin/dmenu_path | ${pkgs.bemenu}/bin/bemenu -l 10)"}";

      # run x11 command in environment
      "${modifier}+shift+x" = "exec ${runInEnvironment "GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb exec ${pkgs.cage}/bin/cage $(${pkgs.dmenu}/bin/dmenu_path | ${pkgs.bemenu}/bin/bemenu -l 10)"}";

      # run terminal in environment
      "${modifier}+shift+Return" = "exec ${runInEnvironment "exec $TERMINAL"}";
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
