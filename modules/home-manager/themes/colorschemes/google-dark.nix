{ config, pkgs, lib, ... }:

with lib;

{
  config = {
    # set default theme colors to google-dark
    themes = {
      colorScheme = "google-dark";
      colorVariant = "dark";
    };

    programs.rofi = {
      extraConfig = builtins.readFile "${pkgs.base16-rofi}/base16-google-dark.config";
      theme = "${pkgs.base16-rofi}/base16-google-dark.rasi";
    };

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        base16-vim
      ];
      extraConfig = mkAfter ''
        colorscheme base16-google-dark
        set background=dark

        let g:airline_theme='base16_google'
      '';
    };

    programs.vscode = {
      userSettings = {
        "workbench.colorTheme" = "Base16 Dark Google";
      };
      extensions = [
        pkgs.my-vscode-extensions.base16-themes
      ];
    };
  };
}
