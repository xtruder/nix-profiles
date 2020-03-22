# creates a sensible i3 desktop setup

{ pkgs, lib, ... }:

with lib;

let
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

    ../profiles/i3.nix
    ../profiles/i3status.nix
    ../profiles/udiskie.nix
    ../profiles/dunst.nix
    ../profiles/xterm.nix
    ../profiles/gnome-keyring.nix
    ../profiles/redhsift.nix
  ];

  config = {
    dconf = {
      enable = true;
      settings."org/gtk/settings/file-chooser" = {
        window-size = "(1920,1038)";
      };
    };

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

    xsession.windowManager.i3.config = {
      startup = [{
        command = "${reclassAppWindow} scratchbrowser firefox -P scratchpad";
        notification = false;
      } {
        command = "env WORKSPACE=scratch ${reclassAppWindow} scratchterm i3-sensible-terminal";
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
}
