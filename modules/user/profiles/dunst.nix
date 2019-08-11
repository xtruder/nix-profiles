{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.dunst;
in {
  options.profiles.dunst = {
    enable = mkEnableOption "dunst profile";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          markup = "yes";
          format = "<b>%s</b>\n%b";
          sort = "yes";
          indicate_hidden = "yes";
          bounce_freq = 0;
          show_age_threshold = 60;
          word_wrap = "yes";
          iservicessline = "no";
          idle_threshold = 120;
          monitor = 0;
          follow = "keyboard";
          sticky_history = "yes";
          startup_notification = false;
          dmenu = "rofi -dmenu -p dunst";
          browser = "chromium -new-tab";
        };
        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };
        urgency_low.timeout = 5;
        urgency_normal.timeout = 20;
        urgency_critical.timeout = 20;
      };
    };
  };
}
