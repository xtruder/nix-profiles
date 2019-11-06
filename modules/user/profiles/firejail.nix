{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.firejail.enable = mkEnableOption "firejail profile";

  config = mkIf config.profiles.firejail.enable {
    nixos.passthru = {
	  security.wrappers = {
		firejail = {
		  source = "${pkgs.firejail.out}/bin/firejail";
		};
	  };
    };
  };
}
