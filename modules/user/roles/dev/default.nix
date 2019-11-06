{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev;
in {
  options.roles.dev.enable = mkEnableOption "dev profile";

  config = mkIf cfg.enable {
    profiles = {
      tmux.enable = true;
      vim.enable = true;
      gpg.enable = true;
    };

    nixos.passthru = {
      programs.adb.enable = true;
      users.groups.adbusers.members = ["offlinehacker"];
    };

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

    programs.git = {
      enable = true;

      userName = config.attributes.admin.fullname; 
      userEmail = config.attributes.admin.email; 

      aliases = {
        "ai" = "add -i";
        "ap" = "add -p";
        "b" = "branch";
        "cf" = "config";
        "ci" = "commit -v";
        "cia" = "commit -v -a";
        "cam" = "commit -a -m";
        "co" = "checkout";
        "cp" = "cherry-pick";
        "d" = "diff";
        "dc" = "diff --cached";
        "dw" = "diff --color-words";
        "dwc" = "diff --cached --color-words";
        "lf" = "log --follow";
        "llf" = "log -p --follow";
        "l" = "log --graph --decorate --abbrev-commit";
        "l1" = "log --graph --decorate --pretty=oneline --abbrev-commit";
        "l1a" = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        "ll" = "log -p --graph --decorate --abbrev-commit";
        "lla" = "log -p --graph --decorate --abbrev-commit --all";
        "resh1" = "reset HEAD^";
        "s" = "!git --no-pager status";
        "sm" = "submodule";
        "st" = "status";
        "tl" = "tag -l";
        "record" = "!sh -c '(git add -p -- $@ && git commit) || git reset' --";
        "cherry-pick-push" = "!sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash && git checkout -B $2 $3 && git cherry-pick $1 && git push -f $4 && git checkout $CURRENT && git stash pop' -";
        "backup" = "!sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash save -a && git checkout -B backup && git stash apply && git add -A . && git commit -m \"backup\" && git push -f $1 && git checkout $CURRENT && git stash pop && git branch -D backup' -";
        "lgb" = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
      };

      ignores = [
        "*~"
        ".#*"
        ".*.sw[op]"
        ".svn"
        ".sw[op]"
        ''\#*#''
        "_"
        "cscope.*"
        "tags"
        ".hg"
        ".notes.md"
        "result"
        "result-*"
        "telepresence.log"
        ".envrc"
      ];

      iniContent = {
        diff.renames = true;
        push.default = "current";
        svn.rmdir = true;
        rebase.autoStash = true;

        color = {
          branch = false;
          diff = "auto";
          status = "auto";
          ui = "auto";
        };

        "color \"diff\"" = {
          "plain" = "normal";
          "meta" = "bold";
          "frag" = "cyan";
          "old" = "white red";
          "new" = "white green";
          "commit" = "yellow";
          "whitespace" = "normal red";
        };

        "color \"branch\"" = {
          "current" = "normal";
          "local" = "normal";
          "remote" = "red";
          "plain" = "normal";
        };

        "color \"status\"" = {
          "header" = "normal";
          "added" = "red";
          "updated" = "green";
          "changed" = "white red";
          "untracked" = "white red";
          "nobranch" = "white red";
        };

        "color \"grep\"" = {
          "match" = "normal";
        };

        "color \"interactive\"" = {
          "prompt" = "normal";
          "header" = "normal";
          "help" = "normal";
          "error" = "normal";
        };
      };

      signing.signByDefault = true;
    };

    programs.chromium = {
      extensions = [
        "pfdhoblngboilpfeibdedpjgfnlcodoo" # websocket tool
        "fhbjgbiflinjbdggehcddcbncdddomop" # postman
        "aicmkgpgakddgnaphhhpliifpcfhicfo" # postman interceptor
        "ihlenndgcmojhcghmfjfneahoeklbjjh" # cvim
        "edacconmaakjimmfgnblocblbcdcpbko" # session buddy
        "ogcgkffhplmphkaahpmffcafajaocjbd" # zenhub
      ];
    };

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
        pkgs.vscode-extensions'.EditorConfig
        pkgs.vscode-extensions'.vim
        pkgs.vscode-extensions'.path-autocomplete
        pkgs.vscode-extensions'.json-schema-validator
        pkgs.vscode-extensions'.all-autocomplete
        pkgs.vscode-extensions'.vscode-proto3
        pkgs.vscode-extensions'.avro
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

      # docker
      docker

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
