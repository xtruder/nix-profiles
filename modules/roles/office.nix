{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.office.enable = mkEnableOption "office role";

  config = mkIf config.roles.office.enable {
    # For office work we need printers
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplipWithPlugin ];

    # For office work we need scanners
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

    environment.systemPackages = with pkgs; [
      (xsane.override { gimpSupport = true; })
    ];
  };
}
