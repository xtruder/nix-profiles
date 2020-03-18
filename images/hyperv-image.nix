{ config, pkgs, lib, nix-profiles, ... }:

{
  imports = with nix-profiles.nixos; [
    hw.hyperv-vm # hw.hyperv-vm-gui for gui support

    # import base environment
    roles.base

    # create user
    profiles.user

    # enable openssh
    profiles.openssh
  ];

  home-manager.users.user = { config, ... }: {
    imports = with nix-profiles.home-manager; [
      # workspaces.i3
      # themes.materia
      # themes.colorscheme.google-dark

      # roles.desktop.dev
    ];
  };

  hyperv = {
    baseImageSize = 4096;
  };

  # recovery = {
  #   sshKey = "<my-ssh-key>";
  #   passwordHash = "<my-password-hash>";
  # };
}
