{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev;
in {
  options.roles.dev.enable = mkEnableOption "dev role";

  config = mkIf cfg.enable (mkMerge [
    {
      home-manager.users.admin.profiles = {
        dev.enable = true;
      };
    }

    (mkIf (config.profiles.docker.enable) {
      # trust all traffic on docker0
      networking.firewall.trustedInterfaces = ["docker0"];
    })
    
    (mkIf config.profiles.vbox.enable {
      # trust all traffic on vbox interfaces
      networking.firewall.trustedInterfaces = ["vboxnet+"];
     })
  ]);
}
