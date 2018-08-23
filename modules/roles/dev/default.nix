{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev;
in {
  options.roles.dev.enable = mkEnableOption "dev role";

  config = mkIf cfg.enable (mkMerge [
    {
      profiles.xonsh.enable = true;
      profiles.xonsh.pythonPackages = with pkgs.python3Packages; [
        numpy
        requests
      ];

      users.defaultUserShell = pkgs.xonsh;

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

        [rebase]
          autoStash = true
      '';

      # additional chromium extensions
      programs.chromium.extensions = [
        "pfdhoblngboilpfeibdedpjgfnlcodoo" # websocket tool
        "fhbjgbiflinjbdggehcddcbncdddomop" # postman
        "aicmkgpgakddgnaphhhpliifpcfhicfo" # postman interceptor
        "ihlenndgcmojhcghmfjfneahoeklbjjh" # cvim
        "edacconmaakjimmfgnblocblbcdcpbko" # session buddy
        "ogcgkffhplmphkaahpmffcafajaocjbd" # zenhub
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
        (overrideDerivation vscode (p: {
          buildInputs = [pkgs.makeWrapper];
          preFixup = ''
            wrapProgram $out/bin/code \
              --add-flags "--extensions-dir /var/run/current-system/sw/share/vscode/extensions"
          '';
        }))
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

        # vscode extensions
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "editorconfig";
            publisher = "EditorConfig";
            version = "0.12.4";
            sha256 = "067mxkzjmgz9lv5443ig7jc4dpgml4pz0dac0xmqrdmiwml6j4k4";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vim";
            publisher = "vscodevim";
            version = "0.13.1";
            sha256 = "18n3qpgv0m79aycjmd55iyzb851hqpdlay0p1k7bypygxaiqnnpv";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-icons";
            publisher = "robertohuertasm";
            version = "7.24.0";
            sha256 = "1lnqxky6wc0yf03zdfsjq7ysv1q32wpcm7ihdl0vb3iqwlhbvl2p";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "path-autocomplete";
            publisher = "ionutvmi";
            version = "1.10.0";
            sha256 = "1vg483sdaxjlzs47ixmhnf6c21kl13flm4lcp7pby98mj8qc1h64";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "json-schema-validator";
            publisher = "tberman";
            version = "0.1.0";
            sha256 = "08460z92j5hmwy9lb13lkiqkhgzhzn9vap71h17qlj7vkxid8q3x";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "all-autocomplete";
            publisher = "Atishay-Jain";
            version = "0.0.16";
            sha256 = "0nklv9fhckpanm9whdk4yx1amc3lg6fv7s2hhl4w1wyrhmp7v955";
          };
        })

        # Protobuffers
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-proto3";
            publisher = "zxh404";
            version = "0.2.1";
            sha256 = "12yf66a9ws5hlyj38nmn91y8a1jrq8696fnmgk60w9anyfalbn4q";
          };
        })

        # Automatically insert license headers
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "licenser";
            publisher = "ymotongpoo";
            version = "1.1.2";
            sha256 = "0icbpbr30d4xayhdhms2fy1hmw3rh7jkp8v46nnnrxcg0z9wc6lz";
          };
        })
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
