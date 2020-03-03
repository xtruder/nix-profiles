{ lib, ... }:

with lib;

{
  imports = [ ./base16.nix ];

  config = {
    # set default theme colors to google-dark
    themes = {
      colorScheme = "google-dark";
      colorVariant = "dark";
    };

    programs.neovim = {
      extraConfig = mkAfter ''
        let g:airline_theme='base16_google'
      '';
    };

    programs.vscode.userSettings = {
      "workbench.colorTheme" = "Base16 Dark Google";
    };
  };
}
