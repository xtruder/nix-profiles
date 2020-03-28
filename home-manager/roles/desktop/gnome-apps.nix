{ config, pkgs, ... }:

let
  imageViewer = ["org.gnome.gThumb.desktop"];
  archiveTool = ["org.gnome.fileRoller.desktop"];
  documentViewer = ["org.gnome.Evince.desktop"];
  textEditor = ["org.gnome.gedit.desktop"];

in {
  config = {
    xdg.mimeApps.defaultApplications = {
      "image/*" = imageViewer;
      "application/zip" = archiveTool;
      "application/rar" = archiveTool;
      "application/7z" = archiveTool;
      "application/*tar" = archiveTool;
      "application/pdf" = documentViewer;
      "text/plain" = textEditor;
    };

    home.packages = with pkgs; [
      gnome3.nautilus
      gnome3.evince
      gnome3.file-roller
      gnome3.gedit
      gthumb
    ];
  };
}
