{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.kubernetes;

in {
  options.profiles.kubernetes = {
    enable = mkEnableOption "Whether to enable kubernetes profile.";
  };

  config = mkIf cfg.enable {
    services.kubernetes.roles = ["master" "node"];
    services.kubernetes.dns.port = 5555;
    services.dnsmasq.servers = ["/${config.services.kubernetes.dns.domain}/127.0.0.1#5555"];
    virtualisation.docker.extraOptions = "--iptables=false --ip-masq=false -b cbr0";
    networking.bridges.cbr0.interfaces = [];
    networking.interfaces.cbr0 = {};
  };
}
