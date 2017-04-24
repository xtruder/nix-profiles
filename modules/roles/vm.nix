{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.vm.enable = mkEnableOption "vm role";

  config = mkIf config.roles.vm.enable {
    roles.work.enable = true;
    roles.system.enable = true;
    roles.headless.enable = true;
  };
}
