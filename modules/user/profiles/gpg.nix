{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.gpg;
  pinentry =
    if config.attributes.hasGui then pkgs.pinentry-gtk2
    else pkgs.pinetry-curses;

in {
  options.profiles.gpg.enable = mkEnableOption "gpg profile";

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      extraConfig = ''
        pinentry-program ${pinentry}/${pinentry.binaryPath or "bin/pinentry"}
      '';
    };
  };
}
