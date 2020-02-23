# dev role defines role used for development, extends work role

{ config, ... }:

{
  imports = [
    ./work.nix
  ];

  config = {
    nix = {
      useSandbox = "relaxed"; # use in relaxed mode on dev environments
      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };
  };
}
