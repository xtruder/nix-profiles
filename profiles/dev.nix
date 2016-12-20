{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.dev;
in {
  options.profiles.dev = {
    enable = mkOption {
      description = "Whether to enable development profile";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    # docker
    virtualisation.docker.enable = mkDefault true;
    virtualisation.docker.storageDriver = mkDefault "overlay2";
    networking.firewall.checkReversePath = mkDefault "loose";

    # virtualbox
    virtualisation.virtualbox.host.enable = mkDefault true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;

    # libvirt
    virtualisation.libvirtd.enable = mkDefault true;
    environment.systemPackages = [pkgs.virtmanager];

    #services.dnsmasq.extraConfig = optionalString (elem "master" config.attributes.tags) ''
    #  dhcp-range=vboxnet0,192.168.56.101,192.168.56.254,4h
    #'';

    programs.npm.enable = true;

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
  };
}
