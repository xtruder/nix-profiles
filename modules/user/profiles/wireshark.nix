{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.wireshark.enable = mkEnableOption "wireshark profile";

  config = mkIf config.profiles.wireshark.enable {
    home.packages = [ pkgs.wireshark ];

    nixos.passthru = {
      programs.wireshark.enable = true;
      user.groups.wireshark.members = [ config.home.username ];
    };
  };
}
