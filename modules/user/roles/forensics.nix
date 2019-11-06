{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.forensics.enable = mkEnableOption "digital forensics role";

  config = mkIf config.roles.forensics.enable {
    home.packages = with pkgs; [
      perlPackages.ImageExifTool
      exiftool
      python3Packages.binwalk
      ghidra-bin
    ];
  };
}
