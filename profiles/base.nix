{ config, lib, pkgs, ... }:

with lib;

{
  time.timeZone = mkDefault "Europe/Berlin";

  # You are not allowed to manage users manually
  users.mutableUsers = mkDefault false;

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
  nix.binaryCaches = [ "https://cache.nixos.org/"  ];
  nix.useSandbox = true;
  nix.distributedBuilds = true;
  nix.package = mkDefault pkgs.nixUnstable;

  # Some basic packages, install other in your profile
  environment.systemPackages = with pkgs.bundle; [base sys];

  programs.bash.enableCompletion = true;

  # Basic additional kernel modules
  boot.kernelModules = [ "atkbd" "tun" "fuse" "overlay" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.sysdig ];

  nixpkgs.config = import ../packages;

  networking.domain = mkDefault config.attributes.projectName;

  services.openssh.enable = true;

  services.journald.extraConfig = ''
    SystemMaxUse=256M
  '';

  nix.binaryCachePublicKeys = ["hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
}
