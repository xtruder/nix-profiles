{ ... }:

{
  imports = [ ./nix.nix ];

  nix = {
    useSandbox = "relaxed"; # use in relaxed mode on dev environments
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
      builders = @/etc/nix/machines
    '';
  };
}
