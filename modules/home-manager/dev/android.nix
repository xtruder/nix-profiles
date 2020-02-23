{ config, pkgs, lib, ... }:

with lib;

{
  config = {
    home.packages = with pkgs; [
      androidenv.androidPkgs_9_0.platform-tools
      apktool
    ];
  };
}
