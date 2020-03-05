# This module defines development NixOS installation ISO

{config, pkgs, lib, nix-profiles, ...}:

{
  imports = with nix-profiles.nixosModules; [
    # define system as iso
    system.iso

    # enable dev environment
    environments.dev

    # create default user
    profiles.user

    # enable openssh
    profiles.openssh
  ];

  home-manager.users.user = {config, ...}: {
    imports = with nix-profiles.homeManagerModules; [
      # use i3 workspace
      workspaces.i3

      # set themes and colorschemes
      themes.materia
      themes.colorscheme.google-dark

      # set dev desktop environment
      environments.desktop.dev

      # enable development profiles
      dev.devops.all
      dev.android
      dev.go
      dev.node
      #dev.elm
      #dev.haskell
      dev.python
      dev.ruby
      dev.nix
    ];
  };
}
