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
    virtualisation.docker.enable = true;
    virtualisation.docker.storageDriver = mkDefault "overlay";

    # virtualbox
    #virtualisation.virtualbox.host.enable = true;
    #nixpkgs.config.virtualbox.enableExtensionPack = true;
  };
}
