{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.virtualbox;
in {
  options.profiles.virtualbox = {
    enable = mkOption {
      description = "Whether to enable development profile";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    # docker
    virtualisation.docker.enable = mkDefault true;
    virtualisation.docker.storageDriver = mkDefault "overlay2";
    networking.firewall.checkReversePath = mkDefault "loose";

    # virtualbox
    virtualisation.virtualbox.host.enable = mkDefault true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;

    services.dnsmasq.extraConfig = optionalString (elem "master" config.attributes.tags) ''
      dhcp-range=vboxnet0,192.168.56.101,192.168.56.254,4h
    '';
  };
}
