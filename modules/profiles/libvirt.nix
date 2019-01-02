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
      hugetlbfs_mount = "/dev/hubepages"
    '';

    services.dnsmasq.extraConfig = ''
      # ignore virbr0 as libvirtd listens here
      except-interface=virbr0
    '';

    boot.kernelParams = ["kvm.allow_unsafe_assigned_interrupts=1" "kvm.ignore_msrs=1" "kvm-intel.nested=1"];

    # required for usb redirection to work
    security.wrappers.spice-client-glib-usb-acl-helper.source =
      "${pkgs.spice_gtk}/bin/spice-client-glib-usb-acl-helper";

    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.virtmanager}/bin/virt-manager &
    '';

    environment.systemPackages = with pkgs; [
      spice-gtk # required for usb redirection to work
      libguestfs
      virtmanager
    ];
  };
}
