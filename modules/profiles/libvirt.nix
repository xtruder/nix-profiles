{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.libvirt;
in {
  options.profiles.libvirt = {
    enable = mkEnableOption "libvirt profile";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm.overrideDerivation (p: {
        patches = p.patches ++ [
          ./nested_svm_disable_blockers.patch
          ./nested_svm_disable_blockers2.patch
        ];
      });
      qemuVerbatimConfig = ''
        namespaces = [];

        # if having virgl gpu issues uncomment
        #seccomp_sandbox = 0
      '';
    };

    networking.firewall.trustedInterfaces = ["virbr0"];
    networking.nat.internalInterfaces = ["virbr0"];
    #networking.nat.externalInterface = "eth0";
    networking.firewall.allowedTCPPortRanges = [{ from = 49152; to = 49215; }];

    users.groups.libvirtd.members = ["${config.users.users.admin.name}"];    

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
      virtviewer
    ];
  };
}
