{ config, lib, pkgs, ... }:

with lib;

{
  options.roles.workstation.enable = mkEnableOption ''
    workstation profiles defines base for all graphical workstation machines
  '';

  config = mkIf config.roles.workstation.enable {
    home-manager.users.admin.roles.workstation.enable = true;

    services.xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;

      layout = "us";

      desktopManager.xterm.enable = false;
      displayManager.slim.enable = true;
    };

    programs.dconf.enable = true;

    services.earlyoom.enable = mkDefault true;

    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
      support32Bit = true;
    };

    hardware.bluetooth.enable = true;

    services.dnsmasq.enable = mkDefault true;
    networking.networkmanager = {
      enable = true;
      insertNameservers = ["127.0.0.1"];
    };

    # Polkit allow kexec
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.policykit.exec") &&
            subject.local && subject.active && subject.isInGroup("users")) {
                return polkit.Result.YES;
        }
      });
    '';
  };
}
