{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.networkmanager.enable = mkEnableOption "network manager with dnsmasq";

  config = mkIf config.profiles.networkmanager.enable {
    networking.networkmanager = {
      enable = mkDefault true;
      insertNameservers = ["127.0.0.1"];
    };

    networking.resolvconf.enable = true;
    services.dnsmasq.enable = mkDefault true;
  };
}
