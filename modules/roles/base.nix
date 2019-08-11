{ config, pkgs, lib, ... }: 

with lib;

{
  config = {
    time.timeZone = mkDefault "Europe/Ljubljana";

    # You are not allowed to manage users manually
    users.mutableUsers = mkDefault false;

    # clean tmp on boot
    boot.cleanTmpDir = mkDefault true;

    users.extraUsers = {
      # default admin user
      admin = {};

      # Deploy ssh key
      root.openssh.authorizedKeys.keys = [ config.attributes.deployKey ];

      # root shell is allways bash shell
      root.shell = mkOverride 50 "${pkgs.bashInteractive}/bin/bash";
    };

    # by default enable all completions
    programs.bash.enableCompletion = mkDefault true;

    # nix config
    nix = {
      binaryCaches = [
        "https://cache.nixos.org/"
        "https://xtruder-public.cachix.org"
      ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "xtruder-public.cachix.org-1:kys+/sTbpYWiTLR9FPSrs70d33lUJCO+OvJoSTZdU0o="
      ];
      useSandbox = "relaxed"; # yes, some security please
      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };

    services.fstrim.enable = true;

    # sane dnsmasq defaults
    services.dnsmasq.extraConfig = ''
      strict-order # obey order of dns servers
    '';

    # sane journald defaults
    services.journald.extraConfig = ''
      SystemMaxUse=256M
    '';

    # our nixpkgs config
    nixpkgs.config.allowUnfree = true;

    # because nixos does not need it's own containers
    boot.enableContainers = mkDefault false;

    # set default domain and hostname
    networking.domain = mkDefault config.attributes.projectName;
    networking.hostName = mkDefault config.attributes.name;

    # enable all firmware
    hardware.enableAllFirmware = mkDefault true;

    # firewall must be allways on, enable NAT
    networking.firewall.enable = mkDefault true;
    networking.nat.enable = mkDefault true;

    environment.variables = {
      EMAIL = mkDefault config.attributes.admin.email;
      FULLNAME = mkDefault config.attributes.admin.fullname;
    };

    # vim as default editor
    programs.vim.defaultEditor = true;

    boot.kernelModules = [ "tun" "fuse" ];

    nix.nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    home-manager.users.admin.attributes = config.attributes;

    environment.systemPackages = with pkgs; [
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
      zip
      xz
      which
      readline
      git
      diffutils
      less
      openssh
      openssl
      jq
      zsh
      nano
      pass
      netcat
      pv
      bind # dig
      hexedit
      nmap
      python
    ];
  };
}
