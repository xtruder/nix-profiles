{ config, pkgs, lib, nix-profiles, ... }:

{
  imports = with nix-profiles.nixosModules; [
    hw.virtualbox-vm

    # import base environment
    environments.base

    # create user
    profiles.user

    # enable openssh
    profiles.openssh
  ];

  home-manager.users.user = { config, ... }: {
    imports = with nix-profiles.homeManagerModules; [
      # workspaces.i3
      # themes.materia
      # themes.colorscheme.google-dark

      # environments.desktop.dev
    ];
  };

  # recovery = {
  #   sshKey = "<my-ssh-key>";
  #   passwordHash = "<my-password-hash>";
  # };
}
