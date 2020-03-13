{ lib, modulesPath, ... }:

with lib;

{
  imports = [
    "${modulesPath}/virtualisation/virtualbox-image.nix"
  ];

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  # Add some more video drivers to give X11 a shot at working in
  # VMware and QEMU.
  services.xserver.videoDrivers = mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];

  virtualbox = {
    vmFileName = "nixos.ova";
  };
}
