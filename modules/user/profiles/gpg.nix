{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.gpg;

in {
  options.profiles.gpg.enable = mkEnableOption "gpg profile";

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
    };
  };
}
