{ config, pkgs, modulesPath, ... }:

with pkgs.lib;

{
    require = [
      <nixpkgs/nixos/modules/programs/virtualbox.nix>
    ];

    virtualisation.libvirtd.enable = true;
    virtualisation.docker.enable = true;
}
