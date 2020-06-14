# virt devops role defines tools for virtualization management

{ config, pkgs, ... }:

{
  imports = [ ../base.nix ];

  config = {
    home.packages = with pkgs; [
      libvirt
      virtmanager
      vagrant
      packer
    ];

    programs.bash.profileExtra = ''
      # sftp-server required by vagrant
      export PATH=${pkgs.openssh}/libexec:$PATH
    '';
  };
}
