{ pkgs }:

{
  base = pkgs.buildEnv {
    name = "pkgs-base";
    paths = with pkgs; [
      coreutils
      utillinux
      procps
      inetutils
      findutils
      iproute
      nettools
      strace
      gnugrep
      gnused
      gawk
      stdenv
      cacert
      ncurses
      file
      tree
      unrar
      curl
      wget
      unzip
      psmisc
      p7zip
      gnutar
      gzip
      xz
      which
      readline
      git
      bash
      diffutils
      less
      openssh
      openssl
      python
      jq
      zsh
      git-crypt
      gnupg
      oh-my-zsh
      autojump
      pythonPackages.dotfiles
      vim_configurable
      nano
      pass
      netcat
      pv
      bind # dig
      hexedit
      imagemagick
      nmap
    ];
    ignoreCollisions = true;
  };

  vim = pkgs.buildEnv {
    name = "pkgs-vim";
    paths = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      molokai

      vim-gitgutter
      syntastic
      YouCompleteMe
      nerdcommenter
      auto-pairs
      vim-closetag
      tagbar
      ctrlp
      editorconfig-vim
    ];
    ignoreCollisions = true;
  };

  pentest = pkgs.buildEnv {
    name = "pkgs-pentest";
    paths = with pkgs; [
      aircrackng
      ettercap
      cutter
      john
      logkeys
      libnfc
      mfcuk
      mfoc
      masscan
      msf
      perlPackages.ImageExifTool
    ];
    ignoreCollisions = true;
  };

  admin = pkgs.buildEnv {
    name = "pkgs-admin";
    paths = with pkgs; [
      # crypto
      mkpasswd
      pwgen
      apacheHttpd # for htpasswd
      xca

      # fs
      s3fs
      gzrt # gzip recovery

      # networking
      nmap
      ncftp
      curl_unix_socket
      socat
      bmon
      tcptrack
      stunnel

      # cloud
      docker
      kubernetes
      awscli

      # database
      sqlite
      mongodb
      mysql55
      postgresql
      redis
      etcdctl

      # remote
      rdesktop
      gtkvnc
    ];
  };

  desktop = pkgs.buildEnv {
    name = "pkgs-desktop";
    paths = with pkgs; [
      # distro tools
      cdrkit
      unetbootin
      winusb

      # cloud storage
      dropbox
      dropbox-cli

      # chat
      weechat

      # windows emulation
      wine
      winetricks
      dosbox

      # p2p stuff
      transmission_gtk

      # telephony
      skype

      # docs/images
      mupdf
      libreoffice
      feh
      (xsane.override { gimpSupport = true; })

      # audio/video
      vlc
      audacity
      xvidcap
      ffmpeg
      nodePackages.peerflix
      youtube-dl

      # remote
      rdesktop
      gtkvnc
    ];
    ignoreCollisions = true;
  };

  dev = pkgs.buildEnv {
    name = "pkgs-dev";
    paths = with pkgs; [
      # networking
      ngrok

      docker
      pythonPackages.docker_compose
    ];
    ignoreCollisions = true;
  };

  games = pkgs.buildEnv {
    name = "pkgs-games";
    paths = with pkgs; [
      steam
      teeworlds
    ];
    ignoreCollisions = true;
  };

  mutltimedia = pkgs.buildEnv {
    name = "pkgs-multimedia";
    paths = with pkgs; [
      gimp # for image editing
      blender # for modelling and animations
      openscad # programative 3d models
      meshlab # for 3d meshes
      freecad # cad, but free
      inkscape # vector graphic tool
      kde4.kdenlive # video editing tool
      dia # diagraming tool
      yed # better diagraming tool
      picard # Music id3 analyzer
      tuxguitar # For my guitar tunes
    ];
    ignoreCollisions = true;
  };

  sys = pkgs.buildEnv {
    name = "pkgs-sys";
    paths = with pkgs; [
      sysdig # System call analyzer

      # fs
      parted
      ntfs3g
      truecrypt
      cryptsetup
      ncdu # disk usage analizer
      unfs3
      encfs

      # devices
      pciutils
      usbutils
      cpufrequtils

      # networking
      dhcp
      tcpdump
      iptables
      wakelan
      bridge_utils
      jnettop
      ethtool
      arp-scan
      openvpn
    ];
  };

  nix = pkgs.buildEnv {
    name = "pkgs-nix";
    paths = with pkgs; [
      nixUnstable
      nix-repl
      vimPlugins.vim-nix
      dpkg
      nix-prefetch-scripts
      nox
      bundix
    ];
  };

  go = pkgs.buildEnv {
    name = "pkgs-nix";
    paths = with pkgs; [
      go
      golint
      gocode
      gotags
    ];
  };

  android = pkgs.buildEnv {
    name = "pkgs-android";
    paths = with pkgs; [
      androidsdk
      apktool
    ];
  };
}