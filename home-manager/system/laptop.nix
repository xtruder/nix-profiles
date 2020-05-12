# system specific overrides for laptops

{ lib, ... }:

with lib;

{
  config = {
    programs.i3status.modules = {
      "battery all".enable = true;
    };
  };
}
