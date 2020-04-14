{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    virtualisation.libvirtd = {
      enable = true;
      # qemuPackage = pkgs.qemu_kvm.overrideDerivation (p: {
      #   patches = p.patches ++ [
      #     ./nested_svm_disable_blockers.patch
      #     ./nested_svm_disable_blockers2.patch
      #   ];
      # });
      qemuVerbatimConfig = ''
        namespaces = [];

        # if having virgl gpu issues uncomment
        seccomp_sandbox = 0
      '';
    };

    virtualisation.kvmgt.enable = true;

    networking = {
      firewall = {
        trustedInterfaces = ["virbr0"];
        allowedTCPPortRanges = [{ from = 49152; to = 49215; }];
      };
      nat.internalInterfaces = ["virbr0"];
    };

    # ignore virbr0 as libvirtd listens here
    services.dnsmasq.extraConfig = ''
      except-interface=virbr0
    '';

    # allow nested virtualization
    boot.kernelParams = ["kvm.allow_unsafe_assigned_interrupts=1" "kvm.ignore_msrs=1" "kvm-intel.nested=1"];

    # required for usb redirection to work
    security.wrappers.spice-client-glib-usb-acl-helper.source =
      "${pkgs.spice_gtk}/bin/spice-client-glib-usb-acl-helper";

    environment.systemPackages = with pkgs; [
      spice-gtk # required for usb redirection to work
      libguestfs
      virtmanager
      virtviewer
    ];
  };
}
