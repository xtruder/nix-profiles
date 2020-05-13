{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.xsession.windowManager.i3;
  modifier = config.xsession.windowManager.i3.config.modifier;

  i3-sway = import ./i3-sway.nix { inherit config cfg lib pkgs; };

in {
  config = {
    # missing package
    home.packages = with pkgs; [ file ];

    xsession.windowManager.i3 = mkMerge [i3-sway {
      enable = true;

      config = {
        keybindings = {
          # print screen
          "Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -z -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f'";

          # print screen select a portion of window
          "${modifier}+Print" = "exec --no-startup-id ${pkgs.scrot}/bin/scrot -zs -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f'";
        };
      };
    }];
  };
}
