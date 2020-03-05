# This module defines development NixOS installation ISO

{config, pkgs, lib, ...}:

let
  nix-profiles = import ../. { inherit pkgs lib; };

in {
  imports = with nix-profiles.modules.nixos; [
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
    imports = with nix-profiles.modules.home-manager; [
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
