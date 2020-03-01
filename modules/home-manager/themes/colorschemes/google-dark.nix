{ config, pkgs, lib, ... }:

with lib;

{
  config = {
    # set default theme colors to google-dark
    themes = {
      colorScheme = "google-dark";
      colorVariant = "dark";
    };

    programs.vim = {
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
