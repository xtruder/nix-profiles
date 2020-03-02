{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.themes;

  colorScheme = mapAttrs (name: value: substring 1 7 value) config.themes.colors;

  # override default materia theme
  materia = pkgs.materia-theme.override {
    themeName = "materia-custom";

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
      MATERIA_COLOR_VARIANT = cfg.colorVariant;
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
    # install customized theme package
    home.packages = with pkgs; [
      materia
      breeze-qt5
      breeze-icons
      papirus-icon-theme
    ];

    # set gtk theme options
    gtk = {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "materia-custom";
        package = materia;
      };
      font = {
        package = pkgs.roboto;
        name = "Roboto 11";
      };
      gtk3.extraConfig.gtk-cursor-theme-name = "breeze";
    };

    xsession.windowManager.i3 = {
      #defaultBarConfig.font = "pango:Material Icons 11, Roboto Mono 11";
      config.fonts = ["RobotoMono 9"];
    };

    # additional theme env variables needed for some apps
    home.sessionVariables = {
      GTK_THEME = "materia-custom";
      GDK_BACKEND = "x11";
    };
  };
}
