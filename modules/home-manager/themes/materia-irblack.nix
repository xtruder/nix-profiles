{ config, lib, pkgs, ... }:

with lib;

let
  colorScheme = mapAttrs (name: value: substring 1 7 value) config.themes.colors;

  # override default materia theme
  materiaIrBlack = pkgs.materia-theme.override {
    themeName = "materia-irblack";

    # set colors for theme
    colors = {
      BG = colorScheme.bg;
      FG = colorScheme.fg;
      BTN_BG = colorScheme.bg;
      BTN_FG = colorScheme.fg;
      MENU_BG = colorScheme.bg;
      MENU_FG = colorScheme.fg;
      ACCENT_BG = colorScheme.blue;
      SEL_BG = colorScheme.blue;
      SEL_FG = colorScheme.bg;
      TXT_BG = colorScheme.bg;
      TXT_FG = colorScheme.fg;
      HDR_BTN_BG = colorScheme.bg;
      HDR_BTN_FG = colorScheme.fg;
      WM_BORDER_FOCUS = colorScheme.blue;
      WM_BORDER_UNFOCUS = colorScheme.alt;
      MATERIA_STYLE_COMPACT = true;
      MATERIA_COLOR_VARIANT = "dark";
      UNITY_DEFAULT_LAUNCHER_STYLE = false;
    };
  };

  i3 = config.xsession.windowManager.i3;

in {
  imports = [
    ./colors.nix
    ./defaults/i3.nix
    ./defaults/dunst.nix
    ./defaults/xresources.nix
    ./defaults/xterm.nix
  ];

  config = {
    # set theme colors to irblack
    themes.colorScheme = "irblack";

    # install customized theme package
    home.packages = [ materiaIrBlack ];

    # set gtk theme options
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "materia-irblack";
        package = materiaIrBlack;
      };
      font = {
        package = pkgs.roboto;
        name = "Roboto 11";
      };
      gtk3.extraConfig.gtk-cursor-theme-name = "breeze";
    };

    # additional theme env variables needed for some apps
    home.sessionVariables = {
      GTK_THEME = "materia-irblack";
      GDK_BACKEND = "x11";
    };
  };
}
