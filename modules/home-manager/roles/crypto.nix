{ config, ... }:

{
  imports = [
    ./work.nix
  ];

  config = {
    home.packages = [
      rippled
      monero-gui
      bitcoin
      electrum
      wagyu
    ];
  };
}
