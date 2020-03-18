{ ... }:

{
  services.xserver.dpi = 227;

  home-manager.defaults = [{
    xresources.properties."Xft.dpi" = 227;
    xsession.pointerCursor.size = 128;
  }];
}
