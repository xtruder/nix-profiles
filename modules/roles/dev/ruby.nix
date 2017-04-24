{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.dev.ruby;
in {
  options.dev.ruby.enable = mkEnableOption "ruby development";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bundler
      ruby
    ];
  };
}
