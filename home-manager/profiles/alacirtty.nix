{ config, pkgs, ... }:

{
  config = {
    programs.terminal.command = "alacritty -e";

    home.packages = with pkgs; [ alacritty ];
  };
}
