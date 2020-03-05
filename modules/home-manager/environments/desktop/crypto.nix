{ config, pkgs, ... }:

{
  imports = [ ../crypto.nix ];

  config = {
    home.packages = with pkgs; [
      monero-gui
      bitcoin
      electrum
      wagyu
    ];
  };
}
