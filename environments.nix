{ pkgs  }:

with pkgs.lib;

rec {
  user = builtins.getEnv "USER";
  group = "users";

  uid = "offlinehacker";
  gid = "users";

  pkgsStdenv = pkgs.buildEnv {
    name = "pkgs-stdenv";
    paths = [pkgs.bundle.base pkgs.bundle.vim];
  };

  nixSandbox = (
    if (builtins.tryEval (import <nix-sandbox>)).success
    then import <nix-sandbox>
    else import (builtins.fetchTarball https://github.com/proteuslabs/nix-sandbox/tarball/master)
  );

  prefix =
    if (builtins.getEnv "NIX_SANDBOX_PREFIX") == ""
    then "/home/${user}/data"
    else builtins.getEnv "NIX_SANDBOX_PREFIX";

  buildEnvironment = configuration: nixSandbox {
    inherit pkgs configuration;
  };

  envOpts = {config, ...}: {
    services.xpra.enable = true;

    preStart = ''
      if mountpoint -q ${prefix}/${config.name}; then
        echo "Environment already mounted"
      else
        echo "Mounting environment"
        mkdir -p ${prefix}/.crypt
        if [ ! -d ${prefix}/.crypt/${config.name} ]; then
          btrfs subvolume create ${prefix}/.crypt/${config.name}
        fi
        sudo ${pkgs.encfs}/bin/encfs --public ${prefix}/.crypt/${config.name} ${prefix}/${config.name}
      fi

      sudo chown ${user}:${group} ${prefix}/${config.name}
      ${concatStrings (mapAttrsToList (n: v: ''
        sudo mkdir -p ${prefix}/${config.name}/${v.name}
        sudo chown ${user}:${group} ${prefix}/${config.name}/${v.name}
      '') config.containers)}
    '';

    postStop = ''
      sudo umount ${prefix}/${config.name}
    '';

    scripts.pushEnv = pkgs.writeScriptBin "${config.name}-push" ''
      #!${pkgs.bash}/bin/bash -e

      BACKUP_SET=$(cat ${prefix}/.snap/${config.name}/set 2>/dev/null || echo "snap")
      LAST_SNAPSHOT_INDEX=$(cat ${prefix}/.snap/${config.name}/$BACKUP_SET-idx 2>/dev/null || echo -1)
      SNAPSHOT_INDEX=$(($LAST_SNAPSHOT_INDEX + 1))
      SNAPSHOT_NAME=$BACKUP_SET-$SNAPSHOT_INDEX
      SNAPSHOT_PATH=${prefix}/.snap/${config.name}/$SNAPSHOT_NAME

      mkdir -p ${prefix}/.snap/${config.name}
      if [ ! -d $SNAPSHOT_PATH ]; then
        btrfs subvolume snapshot -r ${prefix}/.crypt/${config.name} $SNAPSHOT_PATH
      fi

      if [ "$LAST_SNAPSHOT_INDEX" == "-1" ]; then
        echo "Pushing snapshot $SNAPSHOT_NAME"
        sudo btrfs send $SNAPSHOT_PATH | pv -W -D 10 | aws s3 cp - s3://x-truder.snaps/${config.name}/$SNAPSHOT_NAME
      else
        LAST_SNAPSHOT_NAME=$BACKUP_SET-$LAST_SNAPSHOT_INDEX
        LAST_SNAPSHOT_PATH=${prefix}/.snap/${config.name}/$LAST_SNAPSHOT_NAME

        echo "Pushing snapshot $SNAPSHOT_NAME with parent $LAST_SNAPSHOT_NAME"
        sudo btrfs send -p $LAST_SNAPSHOT_PATH $SNAPSHOT_PATH | pv -W -D 10 | aws s3 cp - s3://x-truder.snaps/${config.name}/$SNAPSHOT_NAME

      fi

      echo $SNAPSHOT_INDEX > ${prefix}/.snap/${config.name}/$BACKUP_SET-idx
    '';

    scripts.pullEnv = pkgs.writeScriptBin "${config.name}-pull" ''
      #!${pkgs.bash}/bin/bash -e

      BACKUP_SET=$(cat ${prefix}/.snap/${config.name}/set 2>/dev/null || echo "snap")
      LAST_SNAPSHOT_INDEX=$(cat ${prefix}/.snap/${config.name}/$BACKUP_SET-idx || echo -1)
      LAST_SNAPSHOT_NAME=$BACKUP_SET-$LAST_SNAPSHOT_INDEX
      SNAPSHOT_PATH=${prefix}/.snap/${config.name}/$LAST_SNAPSHOT_NAME

      SNAPSHOT_INDEX=$(aws s3 ls s3://x-truder.snaps/${config.name}/ | tr -s " " | cut -d " "  -f4 | sed -e "s:$BACKUP_SET-::g" | sort -nr | head -n1)
      echo $indexes

      TO_DOWNLOAD=$(seq $(($LAST_SNAPSHOT_INDEX + 1)) $SNAPSHOT_INDEX)
      echo "Downloading snapshots: $TO_DOWNLOAD"
      for i in $TO_DOWNLOAD; do
        SNAPSHOT_NAME=$BACKUP_SET-$i
        SNAPSHOT_PATH=${prefix}/.snap/${config.name}/$SNAPSHOT_NAME

        echo "Pulling snapshot $SNAPSHOT_NAME"
        aws s3 cp s3://x-truder.snaps/${config.name}/$SNAPSHOT_NAME - | pv -W | sudo btrfs receive ${prefix}/.snap/${config.name}
      done

      if [ -d ${prefix}/.crypt/${config.name} ]; then
        sudo btrfs subvolume delete ${prefix}/.crypt/${config.name}
      fi
      sudo btrfs subvolume snapshot $SNAPSHOT_PATH ${prefix}/.crypt/${config.name}

      echo $SNAPSHOT_INDEX > ${prefix}/.snap/${config.name}/$BACKUP_SET-idx
    '';

    scripts.listSnapshots = pkgs.writeScriptBin "${config.name}-ls" ''
      aws s3 cp - s3://x-truder.snaps/${config.name}
    '';

    scripts.attachEnvShell = pkgs.writeScriptBin "${config.name}-attach-shell" ''
      #!${pkgs.bash}/bin/bash

      COMMAND='${pkgs.bash}/bin/bash -c "[[ -n \"%1\" ]] && ${config.scripts.execEnv}/bin/${config.name}-exec %1 zsh || zsh"'
      $TERMINAL -e tmux -L ${config.name} new-session -s ${config.name} "
        tmux bind-key c command-prompt -p container: 'new-window $COMMAND' &&
        tmux bind-key '|' command-prompt -p container: 'split-window -h $COMMAND' &&
        tmux bind-key '-' command-prompt -p container: 'split-window -v $COMMAND' &&
        tmux new-window"
    '';
  };

  defaultOpts = { config, name, ... }: {
    mounts = [
      "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt:/etc/ssl/ca-certificates.crt"
      "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-certificates.crt"
      "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt"
      "${pkgs.coreutils}/bin/env:/usr/bin/env"
      "/etc/passwd:/etc/passwd"
      "/etc/group:/etc/group"
      "/etc/localtime:/etc/localtime"
      "/etc/machine-id:/etc/machine-id"
      "/etc/nsswitch.conf:/etc/nsswitch.conf"
    ];
    workdir = "/home/${user}";

    inherit uid gid;
  };

  X11Opts = {
    xpra.enable = true;
  };

  shellContainer = mkMerge [defaultOpts ({name, config, ...}: {
    packages = [pkgsStdenv];
    mounts = [
      "${pkgsStdenv}:/home/${user}/.nix-profile"
      "$HOME/Dotfiles2:/home/${user}/Dotfiles"
      "${prefix}/${config.envName}/${name}:/home/${user}"
    ];
    command = "zsh -c 'dotfiles -s && zsh -i'";
    tty = true;
    interactive = true;
    env.TERM = "screen-256color";
    env.ENV = "${config.envName}@${config.name}";
  })];

  vpnContainer = {config, ...}: {
    packages = [pkgs.openvpn pkgs.bash];
    command = "bash -c 'while true; do openvpn /etc/openvpn/config.ovpn; done'";
    capAdd = ["NET_ADMIN"];
    devices = ["/dev/net/tun"];
    tty = true;
    interactive = true;
    workdir = "/etc/openvpn";
    mounts = [
      "${prefix}/${config.envName}/${config.name}:/etc/openvpn"
      "/etc/nsswitch.conf:/etc/nsswitch.conf"
    ];
    sidecar.enable = true;
    sidecar.capAdd = ["NET_ADMIN"];
    sidecar.script = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o tap0 -j MASQUERADE
    '';
  };
}
