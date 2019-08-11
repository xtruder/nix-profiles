{ config, options, lib, ... }:

with lib;

let
  passthruPrefixes = [
    "attributes.services"
    "services.dbus"
    "services.geoclue2"
    "users.groups"
    "users.extraGroups"
    "programs.adb"
    "programs.wireshark"
    "networking.networkmanager"
  ];

  passthru = map (prefix: let
    path = splitString "." prefix;
  in
    setAttrByPath path (
      mkMerge (flatten (mapAttrsToList (name: cfg:
        map (m: let
          value = if isFunction m then m {inherit config;} else m;
        in attrByPath path {} value) cfg.nixos.passthru
      ) config.home-manager.users))
    )
  ) passthruPrefixes;
in {
  imports = [
    <home-manager/nixos>
  ];

  options = {
    home-manager.users = mkOption {
      type = types.attrsOf (types.submodule ({...}: {
        imports = import ./user/module-list.nix;
      }));
    };
  };

  config = mkMerge ([{
    home-manager = {
      # installation of user packages through the users.users.<name>.packages 
      useUserPackages = false;
    };
  }] ++ passthru);
}
