{ config, pkgs, ... }:

{
  imports = [
    ./work.nix
  ];

  config = {
    home.packages = with pkgs; [
      rippled
      monero-gui
      bitcoin
      electrum
      wagyu
    ];
  };
}
