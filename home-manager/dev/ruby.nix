{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./base.nix ];

  config = {
    home.packages = with pkgs; [
      bundix
      (hiPrio bundler)
      ruby
    ];
  };
}
