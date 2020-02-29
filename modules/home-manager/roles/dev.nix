{ config, pkgs, ... }:

{
  imports = [ ./work.nix ];

  config = {
    programs.ssh.enable = true;

    programs.bash = {
      enableAutojump = true;
      initExtra = ''
        . ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

        export GIT_PS1_SHOWDIRTYSTATE=1
        export PS1=$PS1'$(__git_ps1 "(%s)") '

        if [ -f ~/.secrets ]; then
          source ~/.secrets
        fi
      '';
    };

    programs.direnv.enable = true;

    programs.vscode = {
      enable = true;
      userSettings = {
        "javascript.validate.enable" = false;
        "window.zoomLevel" = 0;
        "terminal.integrated.rendererType" = "dom";
        "terminal.integrated.shell.linux" = "/run/current-system/sw/bin/bash";
        "go.docsTool" = "godoc";
        "go.formatTool" = "goimports";
        "breadcrumbs.enabled" = true;
      };
      extensions = [
        pkgs.my-vscode-extensions.EditorConfig
        pkgs.my-vscode-extensions.vim
        pkgs.my-vscode-extensions.path-autocomplete
        pkgs.my-vscode-extensions.json-schema-validator
        pkgs.my-vscode-extensions.all-autocomplete
        pkgs.my-vscode-extensions.vscode-proto3
        pkgs.my-vscode-extensions.avro
      ];
    };

    home.packages = with pkgs; [
      jq
      jshon

      # compilation/debugging
      gnumake
      gcc
      patchelf
      binutils
      patchutils
      gdb
      lldb

      # networking
      protobuf
      ngrok

      # messaging
      #zoom-us

      (python.withPackages (ps: [
        ps.sphinx
        ps.sphinxcontrib-blockdiag
      ]))

      # source code managment
      gitAndTools.gitflow
      gitAndTools.hub
      git-crypt

      # encryption
      keybase
      gnupg
    ];
  };
}
