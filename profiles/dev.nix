{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.dev;
in {
  options.profiles.dev = {
    enable = mkOption {
      description = "Whether to enable development profile";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    # docker
    virtualisation.docker.enable = mkDefault true;
    virtualisation.docker.storageDriver = mkDefault "overlay";
    networking.firewall.checkReversePath = mkDefault "loose";

    # virtualbox
    virtualisation.virtualbox.host.enable = mkDefault true;
    #nixpkgs.config.virtualbox.enableExtensionPack = mkDefault true;
  };
}
