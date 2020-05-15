{ config, nix-profiles, ... }:

{
  imports = with nix-profiles.lib.nixos; [
    # qemu-vm hardware profile
    hw.qemu-vm

    # make it work with vagrant
    system.vagrant

    # enable dev environment
    roles.base
  ];
}
