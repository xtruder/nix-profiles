{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./base.nix ];

  config = {
    programs.vscode.extensions = with pkgs.my-vscode-extensions; [
      node-module-intellisense
      docthis
      vscode-eslint
      vscode-mocha-sidebar
    ];

    home.file.".npmrc".text = ''
      prefix = ''${HOME}/.npm
      //registry.npmjs.org/:_authToken=''${NPM_TOKEN}
    '';

    programs.bash.profileExtra = ''
      if [ -z $NPM_TOKEN ]; then
        export NPM_TOKEN=""
      fi
    '';

    programs.neovim.plugins = with pkgs.vimPlugins; [ typescript-vim ];

    home.packages = with pkgs; with nodePackages; [
      nodejs-12_x
      typescript
      node2nix
      flow
      yarn
    ];
  };
}
