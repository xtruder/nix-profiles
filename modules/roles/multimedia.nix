{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.multimedia.enable = mkEnableOption "multimedia role";

  config = mkIf config.roles.multimedia.enable {
    environment.systemPackages = [
      gimp # for image editing
      blender # for modelling and animations
      openscad # programative 3d models
      meshlab # for 3d meshes
      freecad # cad, but free
      inkscape # vector graphic tool
      kde4.kdenlive # video editing tool
      dia # diagraming tool
      yed # better diagraming tool
      picard # Music id3 analyzer
      tuxguitar # For my guitar tunes
      audacity # for music editing and recording
    ];
  };
}
