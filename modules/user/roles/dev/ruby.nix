{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.ruby;
in {
  options.roles.dev.ruby.enable = mkEnableOption "ruby development role";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bundix
      (hiPrio bundler)
      ruby
    ];
  };
}
