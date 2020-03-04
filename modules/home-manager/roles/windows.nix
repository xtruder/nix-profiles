{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      # windows emulation
      wine
      winetricks
    ];
  };
}
