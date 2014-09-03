{ config, pkgs, modulesPath, ... }:

with pkgs.lib;

let
  session_lock = pkgs.writeScript "session-lock" ''
    #!/bin/sh
    ${pkgs.procps}/bin/pkill -HUP gpg-agent # Remove cached password from memory
    ${pkgs.scrot}/bin/scrot /tmp/screen_locked.png
    ${pkgs.imagemagick}/bin/convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked.png
    ${pkgs.libnotify}/bin/notify-send DUNST_COMMAND_PAUSE
    ${pkgs.i3lock}/bin/i3lock -i /tmp/screen_locked.png --nofork
    ${pkgs.libnotify}/bin/notify-send DUNST_COMMAND_RESUME
  '';

  i3exit = pkgs.writeTextFile {
    name = "i3exit";
    text = ''
      #!/bin/sh
      PATH=${pkgs.i3}/bin:${pkgs.systemd}/bin
      case "$1" in
          lock)
              ${session_lock} &
              ;;
          logout)
              i3-msg exit
              ;;
          suspend)
              ${session_lock} &
              systemctl suspend
              ;;
          hibernate)
              ${session_lock} &
              systemctl hibernate
              ;;
          reboot)
              systemctl reboot
              ;;
          shutdown)
              systemctl poweroff
              ;;
          *)
              echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
              exit 2
      esac
      exit 0
    '';
    executable = true;
    destination = "/bin/i3exit";
  };

in {
  services.xserver = {
    enable = true;
    autorun = true;
    exportConfiguration = true;

    layout = "si";

    windowManager.i3.enable = true;
    windowManager.default = "i3";
    displayManager.slim.enable = true;
  };

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    dunst
    dmenu
    i3status
    networkmanagerapplet
    gnome3.gnome_keyring
    xfce.tumbler
    i3exit
    xlibs.xbacklight
  ];
}
