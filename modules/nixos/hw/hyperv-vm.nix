{ pkgs, ... }:

{
  virtualisation.hypervGuest.enable = true;

  attributes.isVM = true;
}
