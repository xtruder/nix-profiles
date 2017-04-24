{ config, pkgs, lib, ... }:

with lib;

{
  options.profiles.wireshark.enable = mkEnableOption "wireshark profile";

  config = mkIf config.profiles.wireshark.enable {
    programs.wireshark.enable = true;

    users.groups.docker.members = ["${config.users.users.admin.name}"];    
  };
}
