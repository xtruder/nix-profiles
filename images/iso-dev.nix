{config, pkgs, lib, nix-profiles, ...}:

{
  imports = with nix-profiles.lib.nixos; [
    # define system as iso
    environments.iso

    # enable dev environment
    roles.dev-workstation

    # create default user
    profiles.user

    # enable openssh
    profiles.openssh
  ];

  home-manager.users.user = {config, ...}: {
    imports = with nix-profiles.lib.home-manager; [
      # use sway workspace
      workspaces.sway-workstation

      # set themes and colorschemes
      themes.materia
      themes.colorscheme.google-dark

      profiles.code-server

      # set dev desktop environment
      roles.desktop.dev

      dev.standard
    ];
  };
}
