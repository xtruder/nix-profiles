{ config, pkgs, lib, ... }:

with lib;

let
  thm = config.themes;

in {
  config = {
    programs.rofi = {
      extraConfig = builtins.readFile "${pkgs.base16-rofi}/base16-${thm.colorScheme}.config";
      theme = "${pkgs.base16-rofi}/base16-${thm.colorScheme}.rasi";
    };

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        base16-vim
      ];
      extraConfig = mkAfter ''
        colorscheme base16-${thm.colorScheme}
        set background=${thm.colorVariant}
      '';
    };

    programs.vscode.extensions = [
      pkgs.my-vscode-extensions.base16-themes
    ];

    programs.bash.initExtra = ''
      shopt -s expand_aliases
      BASE16_SHELL=${pkgs.base16-shell}
      [ -n "$PS1" ] && \
        [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
          eval "$("$BASE16_SHELL/profile_helper.sh")"

      _base16 "$BASE16_SHELL/scripts/base16-${thm.colorScheme}" ${thm.colorScheme}
    '';
  };
}
