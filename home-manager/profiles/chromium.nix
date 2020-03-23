{ config, ... }:

{
  programs.chromium.enable = true;
  nixpkgs.config.enableWideWine = true;
}
