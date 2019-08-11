{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.nix;
in {
  options.roles.dev.nix.enable = mkEnableOption "nix language role";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (hiPrio nixUnstable)
      dpkg
      nix-prefetch-scripts
      nix-prefetch-github
      nix-firefox-addons-generator
    ];

    programs.vim.plugins = [ "vim-nix" ];

    programs.vscode.extensions = [
      pkgs.vscode-extensions.bbenoist.Nix
    ];

    programs.bash.profileExtra = ''
      function nix-path() {
        readlink -f $(which $1)
      }

      function remove_home_roots() {
        nix-store --gc --print-roots | grep -i /home/offlinehacker | cut -d ' ' -f 1 | xargs rm
      }

      # set nixpkgs path to locally clonned nixpkgs
      export NIX_PATH=nixpkgs=$HOME/projects/nixpkgs:$NIX_PATH
    '';
  };
}
