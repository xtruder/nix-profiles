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

    users.groups.libvirtd.members = ["${config.users.users.admin.name}"];    

    virtualisation.libvirtd.qemuVerbatimConfig = ''
      nvram = ["${pkgs.OVMF}/FV/OVMF_CODE.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"]
    '';

    services.dnsmasq.extraConfig = ''
      # ignore virbr0 as libvirtd listens here
      except-interface=virbr0
    '';
  };
}
