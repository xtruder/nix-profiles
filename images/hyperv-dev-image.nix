{config, pkgs, lib, nix-profiles, ...}:

{
  imports = with nix-profiles.nixos; [
    hw.hyperv-vm-gui

    # enable dev environment
    roles.dev

    # create default user
    profiles.user

    # enable openssh
    profiles.openssh
  ];

  home-manager.users.user = {config, ...}: {
    imports = with nix-profiles.home-manager; [
      # use i3 workspace
      workspaces.i3

      # set themes and colorschemes
      themes.materia
      themes.colorscheme.google-dark

      # set dev desktop environment
      roles.desktop.dev

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

  hyperv = {
    baseImageSize = 8192;
  };
}
