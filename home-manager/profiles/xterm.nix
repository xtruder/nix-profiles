{ config, ... }:

{
  config = {
    programs.terminal.command = "xterm -e ";

    programs.tmux.extraConfig = ''
      set -g terminal-overrides ',xterm-256color:Tc'
      set -as terminal-overrides ',xterm*:sitm=\E[3m'
    '';

    xresources.properties = {
      "XTerm*eightBitInput" = false;
      "XTerm*dynamicColors" = true;
      "XTerm*metaSendsEscape" = true;
      "XTerm*selectToClipboard" = true;
      "XTerm*renderFont" = true;
      "XTerm*faceSize" = 10;
      "XTerm*termName" = "xterm-256color";
    };
  };
}
