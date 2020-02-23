{ config, ... }:

{
  imports = [
    # xterm uses colors from xresources
    ./xresources.nix
  ];

  config = {
    xresources.properties = {
      "Xterm*faceName" = "Source Code Pro,Source Code Pro Semibold";
    };
  };
}
