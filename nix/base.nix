{ config, pkgs, modulesPath, ... }:

with pkgs.lib;

{
  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "slovene";
    defaultLocale = "sl_SI.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  # Enable the OpenSSH daemon and allow ssh port forwarding
  services.openssh.enable = true;
  services.openssh.gatewayPorts = "yes";

  # Enable sudo
  security.sudo.enable = true;

  # - Add me as authorized root, so there's no doubt i can login
  # - I only have one root password, but i'm not gona ever give it to u, if
  #   you are sudo you are root anyway so why should i bother
  users.extraUsers.root.openssh.authorizedKeys.keys = [ (builtins.readFile ../keys/id_rsa.pub) ];
  users.extraUsers.root.password = null;
  users.extraUsers.root.passwordFile = toString (pkgs.writeText "pass" "$6$ExruaSVhjryLcFrA$dlDPiMq3JOwu6XICK9AHwevF/67lG0kvQCHTm75wxMkNkMsDcvSm1S5JVSST87nzx5sP1J/ha35gDpeB30qRc.");

  # You are not allowed to manage users manually
  users.mutableUsers = false;

  # clean tmp on boot
  boot.cleanTmpDir = true;

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
  nix.trustedBinaryCaches = [ "http://hydra.nixos.org/" ];
  nix.useChroot = true;

  # Some basic packages, install other in your profile
  environment.systemPackages = with pkgs; [
    zsh
    git
    screen
    vim
    openssl
    nmap
    fuse
  ];
}
