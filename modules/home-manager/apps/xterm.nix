{ config, ... }:

{
  imports = [ ../terminal.nix ];

  config = {
    programs.terminal.command = "xterm -e ";

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
