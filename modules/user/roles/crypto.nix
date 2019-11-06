{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.crypto.enable = mkEnableOption "crypto role";

  config = mkIf config.roles.crypto.enable {
    home.packages = with pkgs; [
      rippled
      monero-gui
      bitcoin
      electrum
      wagyu
    ];
  };
}
