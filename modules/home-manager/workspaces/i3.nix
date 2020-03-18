# creates a sensible i3 desktop setup

{ config, pkgs, ... }:

{
  imports = [
    ./base.nix

    ../apps/i3.nix
    ../apps/i3status.nix
    ../apps/udiskie.nix
    ../apps/dunst.nix
    ../apps/xterm.nix
  ];

  config = {
    dconf.enable = true;

    services.network-manager-applet.enable = true;
    services.gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };

    programs.i3lock = {
      enable = true;
      cmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    };

    programs.rofi.enable = true;

    systemd.user.services.xss-lock.Service.Environment = "PATH=${pkgs.coreutils}/bin";
  };
}
