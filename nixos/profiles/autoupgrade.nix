{ config, lib, ... }:

with lib;

{
  config = {
    system.autoUpgrade = {
      enable = true;

      # always lookup tarball updates
      flags = ["--option" "tarball-ttl" "0"];

      # do not reboot machine by default
      allowReboot = mkDefault false;
    };

    # pull the latest changes from upstream if /etc/nixos is git repo
    systemd.services.nixos-upgrade = {
      preStart = ''
        if [ -d /etc/nixos] && [ -d /etc/nixos/.git ]; then
          cd /etc/nixos
          git pull || echo "cannot pull git changes"
        fi
      '';
    };
  };
}
