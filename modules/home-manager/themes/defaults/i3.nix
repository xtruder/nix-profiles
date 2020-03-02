# i3 specific default theme configuration

{ config, lib, pkgs, ... }:

with lib;

let
  thm = config.themes.colors;

in {
  imports = [
    ../colors.nix
    ../../apps/i3-options.nix
  ];

  xsession.windowManager.i3 = {
    package = pkgs.i3-gaps;

    defaultBarConfig = {
      colors = rec {
        background = mkDefault thm.bg;
        statusline = mkDefault thm.fg;
        focusedWorkspace = {
          border = mkDefault thm.blue;
          background = mkDefault thm.blue;
          text = mkDefault thm.fg;
        };
        activeWorkspace = focusedWorkspace;
        inactiveWorkspace = {
          border = mkDefault thm.dark;
          background = mkDefault thm.bg;
          text = mkDefault thm.gray;
        };
        urgentWorkspace = focusedWorkspace // {
          background = mkDefault thm.orange;
        };
        bindingMode = urgentWorkspace;
      };
    };

    config = {
      colors = rec {
        background = mkDefault thm.bg;
        unfocused = {
          text = mkDefault thm.gray;
          border = mkDefault thm.dark;
          background = mkDefault thm.bg;
          childBorder = mkDefault thm.dark;
          indicator = mkDefault thm.fg;
        };
        focusedInactive = unfocused;
        urgent = unfocused // {
          text = mkDefault thm.fg;
          border = mkDefault thm.orange;
          childBorder = mkDefault thm.orange;
        };
        focused = unfocused // {
          childBorder = mkDefault thm.blue;
          border = mkDefault thm.blue;
          background = mkDefault thm.dark;
          text = mkDefault thm.fg;
        };
      };

      gaps = {
        inner = mkDefault 6;
        smartGaps = mkDefault true;
        smartBorders = mkDefault "on";
      };

      floating = {
        titlebar = mkDefault false;
        border = mkDefault 1;
      };

      window = {
        titlebar = mkDefault false;
        border = mkDefault 1;
        hideEdgeBorders = mkDefault "smart";
      };
    };
  };
}
