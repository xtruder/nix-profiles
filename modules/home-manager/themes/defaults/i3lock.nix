{ config, ... }:

let
  thm = config.themes.colors;

in {
  config = {
    programs.i3lock.colors = {
      inside = thm.blue;
      insideVerify = thm.green;
      insideWrong = thm.red;
      ringVerify = thm.dark;
      ringWrong = thm.dark;
      ring = thm.gray;
      line = thm.fg;
      keyHold = thm.blue;
      backspaceHold = thm.blue;
    };
  };
}
