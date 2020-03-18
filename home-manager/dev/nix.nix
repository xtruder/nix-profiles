{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./base.nix ];

  config = {
    home.packages = with pkgs; [
      (hiPrio nixFlakes)
      dpkg
      nix-prefetch-scripts
      nix-prefetch-github
      #nix-firefox-addons-generator
      #nixfmt
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

      function nix-remove-home-roots() {
        nix-store --gc --print-roots | grep -i $HOME | cut -d ' ' -f 1 | xargs rm
      }

      # set nixpkgs path to locally clonned nixpkgs
      export NIX_PATH=nixpkgs=$HOME/projects/nixpkgs:$NIX_PATH
    '';
  };
}
