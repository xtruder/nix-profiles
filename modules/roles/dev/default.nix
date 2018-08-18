{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev;
in {
  options.roles.dev.enable = mkEnableOption "dev role";

  config = mkIf cfg.enable (mkMerge [
    {
      # save bash history
      programs.bash.loginShellInit = ''
        shopt -s histappend
        PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
      '';

      # my git config
      environment.etc.gitconfig.text = ''
        [core]
          excludesfile = ${pkgs.writeText "gitexclude" ''
            *~
            .#*
            .*.sw[op]
            .svn
            .sw[op]
            \#*#
            _
            cscope.*
            tags
            .hg
          ''}

        [color]
          branch = false
          diff = auto
          status = auto
          ui = auto

        [color "diff"]
          plain = normal
          meta = bold
          frag = cyan
          old = white red
          new = white green
          commit = yellow
          whitespace = normal red

        [color "branch"]
          current = normal
          local = normal
          remote = red
          plain = normal

        [color "status"]
          header = normal
          added = red
          updated = green
          changed = white red
          untracked = white red
          nobranch = white red

        [color "grep"]
          match = normal

        [color "interactive"]
          prompt = normal
          header = normal
          help = normal
          error = normal

        [diff]
          renames = true

        [alias]
          ai = add -i
          ap = add -p
          b = branch
          cf = config
          ci = commit -v
          cia = commit -v -a
          cam = commit -a -m
          co = checkout
          cp = cherry-pick
          d = diff
          dc = diff --cached
          dw = diff --color-words
          dwc = diff --cached --color-words
          lf = log --follow
          llf = log -p --follow
          l = log --graph --decorate --abbrev-commit
          l1 = log --graph --decorate --pretty=oneline --abbrev-commit
          l1a = log --graph --decorate --pretty=oneline --abbrev-commit --all
          ll = log -p --graph --decorate --abbrev-commit
          lla = log -p --graph --decorate --abbrev-commit --all
          resh1 = reset HEAD^
          s = !git --no-pager status
          sm = submodule
          st = status
          tl = tag -l
          record = !sh -c '(git add -p -- $@ && git commit) || git reset' --
          cherry-pick-push = !sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash && git checkout -B $2 $3 && git cherry-pick $1 && git push -f $4 && git checkout $CURRENT && git stash pop' -
          backup = !sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash save -a && git checkout -B backup && git stash apply && git add -A . && git commit -m "backup" && git push -f $1 && git checkout $CURRENT && git stash pop && git branch -D backup' -
          lgb = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches

        [push]
          default = current

        [svn]
          rmdir = true

        [user]
          email = jakahudoklin@gmail.com
          name = Jaka Hudoklin
      '';

      # additional chromium extensions
      programs.chromium.extensions = [
        "pfdhoblngboilpfeibdedpjgfnlcodoo" # websocket tool
        "fhbjgbiflinjbdggehcddcbncdddomop" # postman
        "aicmkgpgakddgnaphhhpliifpcfhicfo" # postman interceptor
        "ihlenndgcmojhcghmfjfneahoeklbjjh" # cvim
        "edacconmaakjimmfgnblocblbcdcpbko" # session buddy
      ];

      # fix for git
      environment.variables.PERL5LIB = ["${pkgs.git}/share/perl5"];

      environment.systemPackages = with pkgs; [
        # browsers
        chromium
        firefox

        gnumake
        gcc
        patchelf
        binutils

        # networking
        ngrok

        # docker
        docker

        # docs
        (python.withPackages (ps: [
          ps.sphinx
          ps.sphinxcontrib-blockdiag
        ]))
        
        # code editors
        vscode
        atom

        # source code managment
        gitAndTools.gitflow
        gitAndTools.gitFull
        gitAndTools.hub
        git-crypt

        # required by tmux
        xsel

        # encryption
        keybase
        gnupg

        # task sync
        pythonPackages.bugwarrior
        super-productivity
      ];
    }
    
    (mkIf config.profiles.kubernetes.enable {
      environment.systemPackages = with pkgs; [
        kubernetes
        kops
        minikube
      ];
    })

    (mkIf (config.profiles.docker.enable) {
      # trust all traffic on docker0
      networking.firewall.trustedInterfaces = ["docker0"];
    })
    
    (mkIf config.profiles.vbox.enable {
      # trust all traffic on vbox interfaces
      networking.firewall.trustedInterfaces = ["vboxnet+"];
     })
  ]);
}
