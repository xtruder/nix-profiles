{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.system.enable = mkEnableOption "system role";

  config = mkIf config.roles.system.enable {
    environment.systemPackages = with pkgs; [
      sysdig # System call analyzer
      htop

      # fs
      parted
      ntfs3g
      truecrypt
      cryptsetup
      ncdu # disk usage analizer
      unfs3
      encfs
      smartmontools

      # devices
      pciutils
      usbutils
      cpufrequtils

      # networking
      dhcp
      tcpdump
      iptables
      wakelan
      bridge_utils
      jnettop
      ethtool
      arp-scan
    ];
  };
}
