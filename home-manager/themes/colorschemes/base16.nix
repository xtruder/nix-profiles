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
        let base16colorspace=256

        if filereadable(expand("~/.vimrc_background"))
          source ~/.vimrc_background
        else
          colorscheme base16-${thm.colorScheme}
          set background=${thm.colorVariant}
        endif
      '';
    };

    programs.vscode.extensions = [
      pkgs.my-vscode-extensions.base16-themes
    ];

    programs.bash.initExtra = ''
      BASE16_SHELL=${pkgs.base16-shell}
      eval "$("$BASE16_SHELL/profile_helper.sh")"
      _base16 "$BASE16_SHELL/scripts/base16-${thm.colorScheme}.sh" ${thm.colorScheme}
    '';
  };
}
