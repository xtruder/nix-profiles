{ config, pkgs, modulesPath, ... }:

with pkgs.lib;

{
    require = [
      <nixpkgs/nixos/modules/programs/virtualbox.nix>
    ];

    # Kernel 3.12 as default with user namespaces support for lxc
    # boot.kernelPackages = pkgs.linuxPackages_3_12;

    virtualisation.libvirtd.enable = true;
}
