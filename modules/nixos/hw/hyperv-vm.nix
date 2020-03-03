{ pkgs, ... }:

{
  virtualisation.hypervGuest.enable = true;

  attributes.hardware.isVM = true;
}
