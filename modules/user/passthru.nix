{ config, lib, ... }:

with lib;

{
  options = {
    nixos.passthru = mkOption {
      type = types.coercedTo types.unspecified (value: [value]) (types.listOf types.unspecified);
      description = "List of modules to passthru";
      default = [];
    };
  };
}
