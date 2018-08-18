{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.docker;
in {
  options.profiles.docker.enable = mkEnableOption "docker profile";

  config = mkIf config.profiles.docker.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.extraOptions = "--dns 172.17.0.1";

    users.groups.docker.members = ["${config.users.users.admin.name}"];    
    environment.systemPackages = with pkgs; [
      docker
      pythonPackages.docker_compose
    ];
  };
}
