{ config, lib, pkgs, ... }:

with lib;

{
  # Select internationalisation properties.
  i18n = {
    consoleFont = mkDefault "lat9w-16";
    consoleKeyMap = mkDefault "slovene";
    defaultLocale = mkDefault "sl_SI.UTF-8";
  };

  time.timeZone = mkDefault "Europe/Berlin";

  # You are not allowed to manage users manually
  users.mutableUsers = false;

  # clean tmp on boot
  boot.cleanTmpDir = mkDefault true;

  # Server recovery key
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    config.attributes.recoveryKey
  ];
  users.extraUsers.root.shell = mkOverride 50 "${pkgs.bash}/bin/bash";

  # Create /bin/bash symlink
  system.activationScripts.binbash = stringAfter [ "binsh" ]
    ''
      mkdir -m 0755 -p /bin
      ln -sfn "${config.system.build.binsh}/bin/sh" /bin/.bash.tmp
      mv /bin/.bash.tmp /bin/bash # atomically replace /bin/sh
    '';

  # Add me as localhost
  networking.extraHosts = ''
    127.0.0.1 ${config.networking.hostName}.${config.networking.domain}
  '';

  # nix
  nix.binaryCaches = [ "http://cache.nixos.org/"  ];
  nix.useChroot = true;

  # Some basic packages, install other in your profile
  environment.systemPackages = with pkgs; [
    git
    screen
    vim
    openssl
    nmap
    tcpdump
    sysdig
    wget
    lsof
    hdparm
  ];

  # Basic additional kernel modules
  boot.kernelModules = [ "atkbd" "tun" "fuse" "overlay" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.sysdig ];

  # Yes please
  nixpkgs.config.allowUnfree = true;

  networking.domain = mkDefault config.attributes.projectName;

  services.openssh.enable = true;

  services.journald.extraConfig = ''
    SystemMaxUse=256M
  '';

  nix.binaryCachePublicKeys = ["hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
}
