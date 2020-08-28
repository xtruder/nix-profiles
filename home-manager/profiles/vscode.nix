{ config, pkgs, ... }:

{
  config = {
    programs.vscode = {
      enable = true;
      userSettings = {
        "window.zoomLevel" = 0;
        "terminal.integrated.rendererType" = "dom";
        "terminal.integrated.shell.linux" = "/run/current-system/sw/bin/bash";
        "breadcrumbs.enabled" = true;
      };
      keybindings = [
        {
          key = "ctrl+alt+m";
          command = "workbench.action.toggleMaximizedPanel";
          when = "!terminalFocus";
        }
        {
          key = "ctrl+`";
          command = "-workbench.action.terminal.toggleTerminal";
          when = "!terminalFocus";
        }
        {
          key = "ctrl+alt+m";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminalFocus";
        }
        {
          key = "ctrl+alt+up";
          command = "workbench.action.navigateUp";
          when = "";
        }
        {
          key = "ctrl+alt+down";
          command = "workbench.action.navigateDown";
        }
        {
          key = "ctrl+alt+left";
          command = "workbench.action.navigateLeft";
        }
        {
          key = "ctrl+alt+right";
          command = "workbench.action.navigateRight";
        }
        {
          key = "ctrl+b";
          command = "workbench.action.toggleSidebarVisibility";
        }
      ];
    };
  };
}
