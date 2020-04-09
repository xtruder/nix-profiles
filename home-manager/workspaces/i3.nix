# creates a sensible i3 desktop setup

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.xsession.windowManager.i3;
  modifier = cfg.config.modifier;

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

in {
  imports = [
    ./base.nix

    ../profiles/xserver.nix
    ../profiles/i3.nix
    ../profiles/i3status.nix
    ../profiles/rofi-pass.nix
    ../profiles/udiskie.nix
    ../profiles/dunst.nix
    ../profiles/xterm.nix
    ../profiles/gnome-keyring.nix
    ../profiles/redhsift.nix
  ];

  config = {
    services.network-manager-applet.enable = mkDefault true;
    services.pasystray.enable = mkDefault true;
    services.blueman-applet.enable = mkDefault true;
    services.random-background = {
      enable = mkDefault true;
      imageDirectory = mkDefault "%h/backgrounds";
    };

    programs.i3lock = {
      enable = true;
      cmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    };

    programs.rofi.enable = true;

    systemd.user.services.xss-lock.Service.Environment = "PATH=${pkgs.coreutils}/bin";

    xsession.windowManager.i3 = {
      defaultBarConfig.statusCommand =
        "${pkgs.python3Packages.py3status}/bin/py3status -c ~/.config/i3status/config";

      config = {
        keybindings = {
          # Show scratchpad terminal
          "${modifier}+t" = ''[class="scratchterm"] scratchpad show, move position center'';

          # Show scratchpad browser
          "${modifier}+b" = ''[class="scratchbrowser"] scratchpad show, move position center'';
        };

        startup = [{
          command = "${reclassAppWindow} scratchbrowser firefox -P scratchpad";
          notification = false;
        } {
          command = "env WORKSPACE=scratch ${reclassAppWindow} scratchterm ${config.programs.terminal.terminalScript}";
          notification = false;
        }];
        window.commands = [
          # move windows with scratchbrowser class to scratchpad and set to smaller size
          {
            criteria.class = "scratchbrowser";
            command = "floating enable, resize set 3440 1876, move window to scratchpad";
          }

          # move windows with scratchterm class to scratchpad and set to smaller size
          {
            criteria.class = "scratchterm";
            command = "floating enable, resize set 3440 1876, move window to scratchpad";
          }
        ];
      };
    };
  };
}
