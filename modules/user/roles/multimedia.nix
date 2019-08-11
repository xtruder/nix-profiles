{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.multimedia.enable = mkEnableOption "multimedia role for multimedia related stuff";

  config = mkIf config.roles.multimedia.enable {
    home.packages = with pkgs; (mkMerge [
      [
        # audio/video
        ffmpeg
        youtube-dl

        # games
        dosbox
      ]

      (mkIf config.attributes.hasGui [
        # audio/video
        vlc
        xvidcap
        nodePackages.peerflix

        # p2p stuff
        transmission_gtk

        blender # for modelling and animations
        openscad # programative 3d models
        meshlab # for 3d meshes
        freecad # cad, but free
        inkscape # vector graphic tool
        kdenlive # video editing tool
        dia # diagraming tool
        yed # better diagraming tool
        picard # Music id3 analyzer
        tuxguitar # For my guitar tunes
        audacity # for music editing and recording
      ])
    ]);
  };
}
