{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      wagyu
    ];
  };
}
