# system specific overrides for laptops

{ lib, ... }:

with lib;

{
  config = {
    # redefine order, add battery status
    programs.i3status.order = [
      (mkOrder 500 "online_status")
      (mkOrder 510 "disk /")
      (mkOrder 520 "load")
      (mkOrder 530 "net_rate")
      (mkOrder 540 "volume master")
      (mkOrder 511 "battery 0")
      (mkOrder 550 "tztime local")
      (mkOrder 551 "tztime pst")
    ];
  };
}
