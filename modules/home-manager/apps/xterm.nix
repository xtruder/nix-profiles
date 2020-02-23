{ config, ... }:

{
  imports = [ ../terminal.nix ];

  config = {
    programs.terminal.command = "xterm -e ";

    xresources.properties = {
      "XTerm*eightBitInput" = false;
      "XTerm*faceSize" = 10;
      "XTerm*dynamicColors" = true;
      "XTerm*metaSendsEscape" = true;
      "XTerm*selectToClipboard" = true;
    };
  };
}
