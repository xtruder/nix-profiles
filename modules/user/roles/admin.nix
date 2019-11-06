{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.admin.enable = mkEnableOption "admin role";

  config = mkIf config.roles.admin.enable {
    profiles.wireshark.enable = true;
	profiles.firejail.enable = true;

    home.packages = with pkgs; (mkMerge [
      [
        # remote
        rdesktop
        gtk-vnc
        virtmanager
        virtviewer
      ]
    ]);
  };
}
