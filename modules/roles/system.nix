{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.system = {
    enable = mkEnableOption "system role";

    enableHibernate = mkOption {
      description = "Whether to enable machine hibernation";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.roles.system.enable {
    # hibernate on power key
    services.logind.extraConfig = ''
      HandlePowerKey=${if config.roles.system.enableHibernate then "hibernate" else "shutdown"}
    '';

    services.udev.packages = with pkgs; [ usb-modeswitch-data  ];

    environment.systemPackages = with pkgs; [
      htop
      config.boot.kernelPackages.bcc

      # fs
      parted
      ntfs3g
      truecrypt
      cryptsetup
      ncdu # disk usage analizer
      unfs3
      encfs
      smartmontools
      hdparm

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
      iw
    ];
  };
}
