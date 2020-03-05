# role to be used on all systems

{ config, lib, ... }:

with lib;

{
  imports = [
    ../base.nix
    ../../attributes.nix

    ../profiles/recovery.nix
  ];

  config = {
    # use UTC by default, do not leak location
    time.timeZone = mkDefault "UTC";

    # You are not allowed to manage users manually by default
    users.mutableUsers = mkDefault false;

    # clean tmp on boot and remove all residuals there
    boot.cleanTmpDir = mkDefault true;

    # i think apple will sue me before oss does
    nixpkgs.config.allowUnfree = true;

    # vim as default editor
    programs.vim.defaultEditor = true;

    # sory eelco some nice idea, but i will stick with go based implementations
    boot.enableContainers = mkDefault false;

    # set default domain and hostname
    networking = {
      domain = mkDefault config.attributes.project;
      hostName = mkDefault config.attributes.name;
    };

    nix = {
      # do builds in sandbox by default
      useSandbox = mkDefault true;

      # set explicit binary cache and add additional binary caches
      binaryCaches = [
        "https://cache.nixos.org/"
        "https://xtruder-public.cachix.org"
      ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "xtruder-public.cachix.org-1:kys+/sTbpYWiTLR9FPSrs70d33lUJCO+OvJoSTZdU0o="
      ];
    };

    system.nixos = {
      versionSuffix = mkDefault ".latest";
      revision = mkDefault "latest";
    };

    # enable earlyoom on all systems
    services.earlyoom.enable = mkDefault true;

    # enable sysdig on all systems
    programs.sysdig.enable = mkDefault true;

    # enable fstrim on all systems, running fstrim weekly is a good practice
    services.fstrim.enable = mkDefault true;

    # replace ntpd by timesyncd
    services.timesyncd.enable = mkDefault true;
  };
}
