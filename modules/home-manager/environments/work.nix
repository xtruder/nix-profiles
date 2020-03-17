{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base.nix

    ../apps/gpg.nix
    ../apps/tmux.nix
    ../apps/vim.nix
  ];

  config = {
    programs.ssh.enable = true;
    programs.direnv.enable = true;

    home.packages = with pkgs; [
      # fetch tools
      aria

      # shell tools
      pet
      fzf

      # vpn
      protonvpn-cli

      # cloud storage
      google-drive-ocamlfuse
      dropbox-cli
    ];
  };
}
