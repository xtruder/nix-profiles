{ pkgs, ... }:

{
  # For office work we need scanners
  hardware.sane = {
    enable = true;

    # enable hp scanners, since this is what i'm usually dealing with
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  services.saned.enable = true;
}
