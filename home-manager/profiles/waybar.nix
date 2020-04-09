{ config, ... }:

{
  config = {
    wayland.windowManager.sway.defaultBarConfig.command = "${pkgs.waybar}/bin/waybar";
  };
}
