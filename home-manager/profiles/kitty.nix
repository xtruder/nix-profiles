{ config, pkgs, ... }:

{
  config = {
    programs.terminal.command = "kitty ";

    home.packages = with pkgs; [ kitty ];
  };
}
