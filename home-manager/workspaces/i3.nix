# creates a sensible i3 desktop setup

{ pkgs, lib, ... }:

with lib;

{
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
    dconf.enable = true;

    services.network-manager-applet.enable = mkDefault true;
    services.pasystray.enable = mkDefault true;

    programs.i3lock = {
      enable = true;
      cmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    };

    programs.rofi.enable = true;

    systemd.user.services.xss-lock.Service.Environment = "PATH=${pkgs.coreutils}/bin";
  };
}
