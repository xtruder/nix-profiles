{ pkgs, ... }:

{
  # For office work we need printing support
  services.printing = {
    enable = true;

    # enable hp printers, since it's what i'm usually dealing with
    drivers = [ pkgs.hplipWithPlugin ];
  };
}
