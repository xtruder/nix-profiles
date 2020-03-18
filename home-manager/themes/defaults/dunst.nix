{ config, lib, ... }:

with lib;

let
  thm = config.themes.colors;

in {
  config.services.dunst.settings = {
    global = {
      geometry = mkDefault "500x5-30+50";
      transparency = mkDefault 10;
      frame_color = thm.blue;
      font = mkDefault "Roboto 10";
      padding = mkDefault 15;
      horizontal_padding = mkDefault 17;
      word_wrap = mkDefault true;
      format = mkDefault ''
        %s %p %I
        %b'';
    };

    urgency_low = {
      background = mkDefault thm.bg;
      foreground = mkDefault thm.fg;
    };

    urgency_normal = {
      background = mkDefault thm.alt;
      foreground = mkDefault thm.fg;
    };

    urgency_critical = {
      background = mkDefault thm.fg;
      foreground = mkDefault thm.bg;
    };
  };
}
