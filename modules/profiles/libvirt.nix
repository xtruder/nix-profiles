{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.libvirt;
in {
  options.profiles.libvirt = {
    enable = mkEnableOption "libvirt profile";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    networking.firewall.trustedInterfaces = ["virbr0"];
    networking.nat.internalInterfaces = ["virbr0"];
    #networking.nat.externalInterface = "eth0";
  };
}
