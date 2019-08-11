{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.themes.numix-solarized;

  CL_BG = "#073642";
  CL_FG = "#ABB2BF";
  CL_CUR = "#2aa198";
  CL_BLACK = "#000000";
  CL_RED = "#dc322f";
  CL_GREEN = "#859900";
  CL_ORANGE = "#cb4b16";
  CL_BLUE = "#268bd2";
  CL_MAGENTA = "#d33682";
  CL_CYAN = "#2aa198";
  CL_WHITE = "#ffffff";
in {
  options.themes.numix-solarized = {
    enable = mkEnableOption "numix-solarized";
  };

  config = mkIf cfg.enable {
    profiles.i3.extraBarConfig = {
      fonts = ["Source Code Pro 8"];
      position = "bottom";
      colors = {
        background = "#073642";
        statusline = "#ffffff";
        separator = "#2aa198";

        focusedWorkspace = { border = "#167AC6"; background = "#167AC6"; text = "#CCCCCC"; };
        activeWorkspace = { border = "#073642"; background = "#5f676a"; text = "#dedede"; };
        inactiveWorkspace = { border = "#073642"; background = "#073642"; text = "#888888"; };
        urgentWorkspace = { border = "#333333"; background = "#900000"; text = "#ffffff"; };
      };
    };

    gtk = {
      theme = {
        name = "NumixSolarizedDarkGreen";
        package = pkgs.numix-solarized-gtk-theme;
      };
      iconTheme = {
        name = "Numix";
        package = pkgs.numix-icon-theme;
      };
    };

    xsession.pointerCursor = {
      name = "Numix";
      package = pkgs.numix-cursor-theme;
    };

    # TODO: find Numix theme
    programs.rofi.theme = "solarized";

    services.dunst.settings = {
      global = {
        alignment = "center";
        transparency = 0;
        line_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "#2aa198";
        geometry = "400x5-6+30";
        font = "Source Code Pro 12";
        frame_width = 1;
        frame_color = "#2aa198";
      };

      urgency_low = {
        background = "#002b36";
        foreground = "#93a1a1";
      };

      urgency_normal = {
        background = "#002b36";
        foreground = "#93a1a1";
      };

      urgency_critical = {
        background = "#002b36";
        foreground = "#93a1a1";
      };

    };

    xsession.windowManager.i3.config = {
      fonts = ["Source Code Pro 8"];
      colors = {
        focused = {
          border = CL_CUR;
          background = CL_CUR;
          text = CL_BG;
          indicator = CL_CUR;
          childBorder = CL_CUR;
        };

        focusedInactive = {
          border = CL_BG;
          background = CL_BG;
          text = CL_CUR;
          indicator = CL_BG;
          childBorder = CL_BG;
        };

        unfocused = {
          border = CL_BG;
          background = CL_BG;
          text = CL_CUR;
          indicator = CL_BG;
          childBorder = CL_BG;
        };

        urgent = {
          border = CL_RED;
          background = CL_RED;
          text = CL_BG;
          indicator = CL_RED;
          childBorder = CL_RED;
        };

        placeholder = {
          border = CL_BG;
          background = CL_BG;
          text = CL_WHITE;
          indicator = CL_BLACK;
          childBorder = CL_BG;
        };
      };
    };

    programs.i3lock = {
      colors = {
        inside = "ffffff22";
        insideVerify = "ffffff22";
        insideWrong = "C6666655";
        ringVerify = "002b36ff";
        ringWrong = "002b36ff";
        ring = "002b36ff";
        line = "1B465100";
        keyhl = "2AA198FF";
        bshl = "2AA198FF";
      };

      clock.enable = true;
      indicator = true;

      background.blur = 5;
      text.wrong = "Drunk?";
      text.verify = "Verifying...";
    };

    programs.vscode.userSettings = {
      "workbench.colorTheme" = "Solarized Dark";
    };

    xresources.extraConfig = ''
      !! Color schemes
      #define S_base03        #002b36
      #define S_base02        #073642
      #define S_base01        #586e75
      #define S_base00        #657b83
      #define S_base0         #839496
      #define S_base1         #93a1a1
      #define S_base2         #eee8d5
      #define S_base3         #fdf6e3

      *background:            S_base03
      *foreground:            S_base0
      *fadeColor:             S_base03
      *cursorColor:           S_base1
      *pointerColorBackground:S_base01
      *pointerColorForeground:S_base1

      #define S_yellow        #b58900
      #define S_orange        #cb4b16
      #define S_red           #dc322f
      #define S_magenta       #d33682
      #define S_violet        #6c71c4
      #define S_blue          #268bd2
      #define S_cyan          #2aa198
      #define S_green         #859900

      !! black dark/light
      *color0:                S_base02
      *color8:                S_base01

      !! red dark/light
      *color1:                S_red
      *color9:                S_orange

      !! green dark/light
      *color2:                S_green
      *color10:               S_base01

      !! yellow dark/light
      *color3:                S_yellow
      *color11:               S_base00

      !! blue dark/light
      *color4:                S_blue
      *color12:               S_base0

      !! magenta dark/light
      *color5:                S_magenta
      *color13:               S_violet

      !! cyan dark/light
      *color6:                S_cyan
      *color14:               S_base1

      !! white dark/light
      *color7:                S_base2
      *color15:               S_base3

      !! xterm fonts
      XTerm*faceName: Source Code Pro,Source Code Pro Semibold
     
      Xft.autohint: 0
      Xft.antialias: 1
    '';

    home.packages = with pkgs; [
      gtk_engines
      gtk-engine-murrine
      numix-cursor-theme
    ];
  };
}
