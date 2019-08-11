{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.android;
in {
  options.roles.dev.android.enable = mkEnableOption "android development";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      #androidsdk_9_0
      apktool
    ];

    programs.adb.enable = true;
    users.groups.adbusers.members = ["${config.users.users.admin.name}"];
  };
}
