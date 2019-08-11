{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.android;
in {
  options.roles.dev.android.enable = mkEnableOption "android development role";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      androidsdk_9_0
      apktool
    ];
  };
}
