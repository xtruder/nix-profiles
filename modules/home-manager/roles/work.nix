{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../apps/gpg.nix
    ../apps/tmux.nix
    ../apps/vim.nix
  ];

  config = {
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
