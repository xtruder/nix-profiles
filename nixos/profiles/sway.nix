{ config, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export GIO_EXTRA_MODULES=${pkgs.dconf.lib}/lib/gio/modules
    '';
  };
}
