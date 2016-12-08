{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.dnscrypt;

in {
  options.profiles.dnscrypt = {
    enable = mkOption {
      description = "Whether to enable dnscrypt profile.";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    # dnscrypt proxy
    services.dnscrypt-proxy = {
      enable = true;
      resolverName = "dnscrypt.eu-dk";
      localPort = 6666;
    };

    services.dnsmasq.servers = ["127.0.0.1#6666"];
  };
}
