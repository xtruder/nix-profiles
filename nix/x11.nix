{ config, pkgs, modulesPath, ... }:

with pkgs.lib;

let
  xflock4 = pkgs.writeScript "xflock4"
    ''
    #!/usr/bin/env bash
    ${pkgs.procps}/bin/pkill -HUP gpg-agent # Remove cached password from memory
    ${pkgs.scrot}/bin/scrot /tmp/screen_locked.png
    ${pkgs.imagemagick}/bin/convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked.png
    ${pkgs.libnotify}/bin/notify-send DUNST_COMMAND_PAUSE
    ${pkgs.i3lock}/bin/i3lock -i /tmp/screen_locked.png --nofork
    ${pkgs.libnotify}/bin/notify-send DUNST_COMMAND_RESUME
    '';

in {
  services.xserver = {
    enable = true;
    autorun = true;
    exportConfiguration = true;

    layout = "si";

    windowManager.i3.enable = true;
    windowManager.default = "i3";
    displayManager.slim.enable = true;
    desktopManager.xfce.enable = true;
    desktopManager.default = "xfce";
  };

  networking.networkmanager.enable = true;

  system.activationScripts.xflock4 = ''ln -fs ${xflock4} /usr/bin/xscreensaver-command'';

  environment.systemPackages = with pkgs; [
    dunst
    networkmanagerapplet
    networkmanager_openvpn
    gnome.gnome_keyring
    xfce.tumbler
  ];
}
