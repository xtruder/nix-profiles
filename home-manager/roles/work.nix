{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base.nix

    ../profiles/gpg.nix
    ../profiles/tmux.nix
    ../profiles/vim.nix
  ];

  config = {
    programs = {
      ssh.enable = true;
      direnv.enable = true;
    };

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

      # password managment
      pass
    ];
  };
}
