# role to be used on all systems

{ config, lib, ... }:

with lib;

{
  imports = [
    ../profiles/nix.nix
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

    # i use other means to read nixos docs
    documentation.doc.enable = mkDefault false;

    system.nixos = {
      versionSuffix = mkDefault ".latest";
      revision = mkDefault "latest";
    };

    # enable earlyoom on all systems
    services.earlyoom.enable = mkDefault true;

    # enable fstrim on all systems, running fstrim weekly is a good practice
    services.fstrim.enable = mkDefault true;

    # replace ntpd by timesyncd
    services.timesyncd.enable = mkDefault true;
  };
}
