# creates a sensible sway desktop setup

{ ... }:

{
  imports = [
    ./base.nix

    ../profiles/wayland.nix
    ../profiles/sway.nix
    ../profiles/swayidle.nix
    #../profiles/waybar.nix
    ../profiles/mako.nix
    ../profiles/alacirtty.nix
    ../profiles/rofi.nix
  ];

  xsession.preferStatusNotifierItems = true;
}
