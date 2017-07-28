{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.ruby;
in {
  options.roles.dev.ruby.enable = mkEnableOption "ruby development";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bundix
      bundler
      ruby
    ];
  };
}
