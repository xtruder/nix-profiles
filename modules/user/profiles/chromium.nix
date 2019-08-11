{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.chromium;
in {
  options.profiles.chromium.enable = mkEnableOption "chromium profile";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        "klbibkeccnjlkjkiokjodocebajanakg" # the great suspender
        "chlffgpmiacpedhhbkiomidkjlcfhogd" # pushbullet
        "mbniclmhobmnbdlbpiphghaielnnpgdp" # lightshot
        "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "naepdomgkenhinolocfifgehidddafch" # browserpass
        "kajibbejlbohfaggdiogboambcijhkke" # mailvelope
      ];
    };

    programs.browserpass = {
      enable = true;
      browsers = ["firefox" "chromium"];
    };
  };
}
