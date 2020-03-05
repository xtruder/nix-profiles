{ config, pkgs, ... }:

{
  imports = [ ./work.nix ];

  config = {
    programs.ssh.enable = true;

    programs.bash = {
      enable = true;
      enableAutojump = true;
      initExtra = ''
        . ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

        export GIT_PS1_SHOWDIRTY  STATE=1
        export PS1=$PS1'$(__git_ps1 "(%s)") '

        if [ -f ~/.secrets ]; then
          source ~/.secrets
        fi
      '';
    };

    programs.direnv.enable = true;

    home.packages = with pkgs; [
      # parsing tools
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
