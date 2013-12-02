{ config, pkgs, ... }:

{
  require = [
    <nixos/modules/profiles/all-hardware.nix>
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/".device = "/dev/disk/by-label/nixos";
}
