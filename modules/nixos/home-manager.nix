{ config, lib, pkgs, home-manager, ... }:

with lib;

{
  # import home manager
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options = {
    home-manager.users = mkOption {
      type = types.attrsOf (types.submodule ({...}: {
        imports = [ ../attributes.nix ];

        config = {
          # passthru pkgs
          _module.args.pkgs = mkForce pkgs;

          # passthru attributes
          attributes = config.attributes;
        };
      }));
    };
  };

  config = {
    home-manager = {
      # installation of user packages through the users.users.<name>.packages
      useUserPackages = mkDefault true;
    };
  };
}
