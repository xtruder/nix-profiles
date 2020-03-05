{ config, lib, pkgs, ... }:

with lib;

{
  # import home manager
  imports = [
    <home-manager/nixos>
  ];

  options = {
    home-manager.users = mkOption {
      type = types.attrsOf (types.submodule ({...}: {
        imports = [ ../attributes.nix ];

        config = {
          # passthru pkgs
          _module.args.pkgs = pkgs;

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
