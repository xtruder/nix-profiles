{ config, pkgs, ... }:

{
  imports = [
    ./base.nix

    ../apps/i3.nix
    ../apps/i3status.nix
    ../apps/udiskie.nix
    ../apps/dunst.nix
  ];

  config = {
    programs.i3lock = {
      enable = true;
      cmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    };

    programs.rofi.enable = true;

    systemd.user.services.xss-lock.Service.Environment = "PATH=${pkgs.coreutils}/bin";
  };
}
