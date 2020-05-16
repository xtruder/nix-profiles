{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base.nix

    ../profiles/gpg.nix
    ../profiles/tmux.nix
    ../profiles/vim.nix
    ../profiles/ssh.nix
  ];

  config = {
    programs.direnv.enable = true;

    home.packages = with pkgs; [
      # utils
      killall

      # cpu monitoring
      htop

      # fetch tools
      aria

      # shell tools
      pet
      fzf

      # password managment
      pass-wayland
    ];
  };
}
