{ config, pkgs, lib, ... }:

with lib;

{
  options.roles.vm.enable = mkEnableOption "vm role";

  config = mkIf config.roles.vm.enable {
    roles.work.enable = true;
    roles.system.enable = true;
    roles.headless.enable = true;

    # eth0 is by default external interface
    networking.nat.externalInterface = mkDefault "eth0";
  };
}
