{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.desktop;

in {
  options.profiles.desktop = {
    enable = mkOption {
      description = "Whether to enable desktop profile.";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    profiles.x11.enable = mkDefault true;

    # dbus
    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.gnome3.gconf pkgs.blueman ];
    services.udisks2.enable = true;

    # Polkit
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.policykit.exec") &&
            subject.local && subject.active && subject.isInGroup("users")) {
                return polkit.Result.YES;
        }
      });
    '';

    # Printing
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplipWithPlugin ];
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

    # Bluetooth
    hardware.bluetooth.enable = true;

    # audio
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.pulseaudio.extraConfig = ''
      load-module module-switch-on-connect
    '';

    # keylogger
    systemd.services.keylogger = {
      description = "keylogger";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.logkeys}/bin/logkeys -s";
        ExecStop = "${pkgs.logkeys}/bin/logkeys -k";
        Type = "forking";
      };
    };

    # Smart cards
    services.pcscd.enable = true;

    # Enable network manager on laptops
    networking.networkmanager.enable = mkDefault (elem "laptop" config.attributes.tags);

    environment.systemPackages = [ pkgs.alsaUtils pkgs.pavucontrol ];
  };
}
