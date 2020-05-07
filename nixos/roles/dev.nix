# dev role defines role used for development, extends work role

{ config, ... }:

{
  imports = [
    ./work.nix
  ];

  config = {
    programs.firejail.enable = true;

    nix = {
      useSandbox = "relaxed"; # use in relaxed mode on dev environments
      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
        builders = @/etc/nix/machines
      '';
    };
  };
}
