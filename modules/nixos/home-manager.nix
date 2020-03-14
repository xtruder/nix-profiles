{ config, lib, pkgs, home-manager, ... }:

with lib;

let
  cfg = config.home-manager;

in {
  # import home manager
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options = {
    home-manager.defaults = mkOption {
      description = "Home manager defaults applied to every user";
      type = types.listOf types.attrs;
      default = [];
    };

    home-manager.users = mkOption {
      type = types.attrsOf (types.submodule ({...}: {
        imports = cfg.defaults;
      }));
    };
  };

  config = {
    home-manager = {
      # installation of user packages through the users.users.<name>.packages
      useUserPackages = mkDefault true;

      defaults = [{
        imports = [ ../attributes.nix ];

        config = {
          # passthru pkgs
          _module.args.pkgs = mkForce pkgs;

          # passthru attributes
          attributes = config.attributes;
        };
      }];
    };
  };
}
