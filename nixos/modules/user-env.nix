{ lib, ... }:

with lib;

{
  options.user-env = {
    environments = mkOption {
      type = types.attrsOf (types.submodule ({ config, name, ... }: {
        options = {
          name = mkOption {
            description = "Environment name";
            type = types.str;
            default = name;
          };

          configuration = mkOption {
            description = "Environment configuration";
            type = types.listOf types.unspecified;
          };
        };
      }));
      default = {};
    };

    defaults = mkOption {
      description = "Default environment configuration";
      type = types.listOf types.unspecified;
      default = [];
    };
  };
}
