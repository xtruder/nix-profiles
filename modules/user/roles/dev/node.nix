{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.node;
  nodePackages = pkgs.nodePackages_10_x;
  nodejs = pkgs.nodejs-10_x;
in {
  options.roles.dev.node.enable = mkEnableOption "node language";

  config = mkIf cfg.enable {
    programs.vscode.extensions = [
      pkgs.vscode-extensions'.node-module-intellisense
      pkgs.vscode-extensions'.docthis
      pkgs.vscode-extensions'.vscode-eslint
      pkgs.vscode-extensions'.vscode-mocha-sidebar
    ];

    programs.npm = {
      enable = true;
      npmrc = ''
        prefix = ''${HOME}/.npm
        //registry.npmjs.org/:_authToken=''${NPM_TOKEN}
      '';
    };

    programs.bash.initExtra = ''
      if [ -z $NPM_TOKEN ]; then
        export $NPM_TOKEN=""
      fi
    '';

    programs.vim.plugins = [ "typescript-vim" ];

    home.packages = with pkgs; with nodePackages; [
      nodejs
      typescript
      node2nix
      flow
      yarn
    ];
  };
}
