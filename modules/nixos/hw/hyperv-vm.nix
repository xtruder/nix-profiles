{ pkgs, ... }:

{
  virtualisation.hypervGuest.enable = true;

  services.xserver = {
    modules = [ pkgs.xorg.xf86videofbdev ];
    videoDrivers = [ "hyperv_fb" ];
  };
}
