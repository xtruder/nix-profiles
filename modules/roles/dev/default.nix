{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev;
in {
  options.roles.dev.enable = mkEnableOption "dev role";

  config = mkIf cfg.enable (mkMerge [
    {
      profiles.xonsh.enable = false;
      profiles.xonsh.pythonPackages = with pkgs.python3Packages; [
        numpy
        requests
      ];

      users.defaultUserShell = pkgs.bashInteractive;

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
            .notes.md
            result
            result-*
            telepresence.log
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
          email = ${config.attributes.admin.email}
          name = ${config.attributes.admin.fullname}

        [rebase]
          autoStash = true

        [commit]
          gpgsign = true

        [gpg]
          program = gpg2
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

      # Create /bin/bash symlink
      system.activationScripts.binbash = stringAfter [ "binsh" ]
        ''
          mkdir -m 0755 -p /bin
          ln -sfn "${config.system.build.binsh}/bin/sh" /bin/.bash.tmp
          mv /bin/.bash.tmp /bin/bash # atomically replace /bin/sh
        '';

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
        protobuf

        # networking
        ngrok

        # docker
        docker

        # docs
        pencil # mockups

        # messaging
        zoom-us

        (python.withPackages (ps: [
          ps.sphinx
          ps.sphinxcontrib-blockdiag
        ]))
        
        # code editors
        (overrideDerivation vscode (p: {
          buildInputs = [pkgs.makeWrapper];
          preFixup = ''
            wrapProgram $out/bin/code \
              --add-flags "--disable-gpu" \
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
        python36Packages.bugwarrior
        super-productivity

        # vscode extensions
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "editorconfig";
            publisher = "EditorConfig";
            version = "0.12.6";
            sha256 = "01x6fa7n3f8c1hwah23i4wzjcl5xdk1wrpg9y9k34n5xbsn2l6q5";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vim";
            publisher = "vscodevim";
            version = "0.17.2";
            sha256 = "18n3qpgv0m79aycjmd55iyzb851hqpdlay0p1k7bypygxaiqnnpv";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-icons";
            publisher = "robertohuertasm";
            version = "8.0.0";
            sha256 = "0kccniigfy3pr5mjsfp6hyfblg41imhbiws4509li31di2s2ja2d";
          };
        })

        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "path-autocomplete";
            publisher = "ionutvmi";
            version = "1.13.1";
            sha256 = "0583k0b9l453b8xf86g1ba7gzxqab2m1ca0dsk5p81flrg77815d";
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
            version = "0.0.18";
            sha256 = "03nsx8hvid1pqvya1xjfmz4p0yj243a8xx9l7yvjz9y72c75qlzc";
          };
        })

        # Protobuffers
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-proto3";
            publisher = "zxh404";
            version = "0.2.2";
            sha256 = "1gasx3ay31dy663fcnhpvbys5p7xjvv30skpsqajyi9x2j04akaq";
          };
        })

        # avro
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "avro";
            publisher = "streetsidesoftware";
            version = "0.4.0";
            sha256 = "0ak7rxraiafgnrmbzzdf96ihg1rkx1srhawr6yy6qcvnxr7b2pj6";
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
