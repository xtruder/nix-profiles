# creates a sensible i3 desktop setup

{ config, pkgs, ... }:

{
  imports = [
    ./base.nix

    ../profiles/i3.nix
    ../profiles/i3status.nix
    ../profiles/udiskie.nix
    ../profiles/dunst.nix
    ../profiles/xterm.nix
    ../profiles/gnome-keyring.nix
  ];

  config = {
    dconf.enable = true;

    services.network-manager-applet.enable = true;

    programs.i3lock = {
      enable = true;
      cmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    };

    programs.rofi.enable = true;

    systemd.user.services.xss-lock.Service.Environment = "PATH=${pkgs.coreutils}/bin";
  };
}
