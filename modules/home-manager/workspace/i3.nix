{ config, ... }:

{
  imports = [
    ./base.nix

    ../apps/i3.nix
    ../apps/i3status.nix
    ../apps/udiskie.nix
    ../apps/dunst.nix
  ];

  config = {
    programs.i3lock.enable = true;
    programs.rofi.enable = true;
  };
}
