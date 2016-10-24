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

  config = mkIf cfg.enable (mkMerge [{
    # dnscrypt proxy
    services.dnscrypt-proxy = {
      enable = true;
      resolverName = "dnscrypt.eu-dk";
    };
  } (mkIf config.networking.networkmanager.enable {
    networking.networkmanager.insertNameservers = ["127.0.0.1"];
  })]);
}
