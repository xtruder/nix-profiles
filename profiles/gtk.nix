{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.gtk;
in {
  options.profiles.gtk = {
    enable = mkOption {
      description = "Whether to enable gtk profile";
      default = config.profiles.x11.enable;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome3.dconf
      lxappearance
      gnome-breeze
      breeze-icons
      gnome3.adwaita-icon-theme
      gtk_engines
      gtk-engine-murrine
      gcolor2
    ];

    environment.variables = {
      GIO_EXTRA_MODULES = [ "${pkgs.gnome3.dconf}/lib/gio/modules" ];
      GTK_DATA_PREFIX = "/run/current-system/sw";
      GST_PLUGIN_SYSTEM_PATH_1_0 =
        lib.makeSearchPath "/lib/gstreamer-1.0"
        (builtins.map (pkg: pkg.out) (with pkgs.gst_all_1; [
          gstreamer
          gst-plugins-base
          gst-plugins-good
          gst-plugins-ugly
          gst-plugins-bad
          gst-libav # for mp3 playback
        ]));
      GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
    };

    environment.shellInit = ''
      export GTK2_RC_FILES=/home/$USER/.gtkrc-2.0
    '';
  };
}
