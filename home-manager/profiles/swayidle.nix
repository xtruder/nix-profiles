{ config, pkgs, ... }:

{
  services.swayidle = {
    enable = true;

    timeout = [{
      duration = 60;
      command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
    } {
      duration = 90;
      command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
      resume = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
    }];

    beforeSleep = [
      ''${pkgs.swaylock}/bin/swaylock -f -c 000000''
    ];

    lock = [
      ''${pkgs.swaylock}/bin/swaylock -f -c 000000''
    ];
  };
}
