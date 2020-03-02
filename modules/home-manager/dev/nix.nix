{ config, pkgs, lib, ... }:

with lib;

{
  config = {
    home.packages = with pkgs; [
      (hiPrio nixUnstable)
      dpkg
      nix-prefetch-scripts
      nix-prefetch-github
      nix-firefox-addons-generator
      nixfmt
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ vim-nix ];

    programs.vscode.extensions = [
      pkgs.vscode-extensions.bbenoist.Nix
      pkgs.my-vscode-extensions.nixfmt-vscode
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
