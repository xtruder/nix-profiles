# virt devops role defines tools for virtualization management

{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      libvirt
      virtmanager
      vagrant
      packer
    ];
  };
}
