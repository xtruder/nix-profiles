{ config, pkgs, lib, ... }:

with lib;

{
  options.profiles.printingAndScanning.enable = mkEnableOption "printing and scanning profile";

  config = mkIf config.profiles.printingAndScanning.enable {
    # For office work we need printers
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplipWithPlugin ];

    # For office work we need scanners
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
    services.saned.enable = true;

    environment.systemPackages = with pkgs; [
      (xsane.override { gimpSupport = true; })
    ];

    users.groups.scanner.members = ["${config.users.users.admin.name}"];
    users.groups.lp.members = ["${config.users.users.admin.name}"];
  };
}
