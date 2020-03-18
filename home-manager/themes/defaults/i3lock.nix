{ config, lib, ... }:

with lib;

let
  thm = config.themes.colors;

  mkColor = c: "00" + (substring 1 8 c);

in {
  config = {
    #programs.i3lock.colors = {
      #inside = mkColor thm.blue;
      #insideVerify = mkColor thm.green;
      #insideWrong = mkColor thm.red;
      #ringVerify = mkColor thm.dark;
      #ringWrong = mkColor thm.dark;
      #ring = mkColor thm.gray;
      #line = mkColor thm.fg;
      #keyHold = mkColor thm.blue;
      #backspaceHold = mkColor thm.blue;
    #};
  };
}
