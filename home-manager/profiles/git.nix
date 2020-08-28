{ config, ... }:

{
  config = {
    home.sessionVariables = {
      GIT_USERNAME = config.programs.git.userName;
      GIT_USEREMAIL = config.programs.git.userEmail;
    };

    programs.git = {
      enable = true;

      #userName = config.attributes.admin.fullname;
      #userEmail = config.attributes.admin.email;

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

      #signing.signByDefault = true;
    };
  };
}
