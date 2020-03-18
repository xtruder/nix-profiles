{ config, lib, ... }:

with lib;

{
  config = {
    # enable networkmanager on all workstations and use local dnsmasq server
    networking.networkmanager = {
      enable = true;

      # always use local dnsmasq for dns server
      insertNameservers = ["127.0.0.1"];
    };

    # enable dnsmasq for dns caching server
    services.dnsmasq = {
      enable = mkDefault true;

      # additional secure configuration for dnsmasq
      extraConfig = ''
        strict-order # obey strict order of dns servers
      '';
    };

    # enable resolvconf
    networking.resolvconf.enable = true;

    # disable wpasupplicant, as networkmanager manages wireless
    networking.wireless.enable = false;
  };
}
