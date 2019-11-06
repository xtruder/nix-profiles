{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.xsession;
in {
  options.profiles.xsession = {
    enable = mkEnableOption "xsession";
    compositor = mkEnableOption "compton compositor";
  };

  config = mkIf cfg.enable {
    xsession.enable = true;
    services.screen-locker.enable = !config.attributes.hardware.isVM; 

    systemd.user.services.polkit-auth-agent = {
      Unit = {
        Description = "polkit authentication agent";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    services.compton.enable = cfg.compositor;

    gtk.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk"; # use gtk theme for qt
    };

    # enable dconf on dbus
    dconf.enable = true;

    home.packages = with pkgs; [
      xorg.xev xsel xfontsel
    ];

    # workaround for dconf to work
    home.sessionVariables = {
      GIO_EXTRA_MODULES = "${getLib pkgs.gnome3.dconf}/lib/gio/modules";
      GTK_USE_PORTAL = "0";
    };
  };
}
