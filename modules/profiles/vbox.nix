{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.vbox;
in {
  options.profiles.vbox.enable = mkEnableOption "docker profile";

  config = mkIf config.profiles.vbox.enable {
    # virtualbox
    virtualisation.virtualbox.host.enable = true;

    # add admin user to vboxusers
    users.groups.vboxusers.members = ["${config.users.users.admin.name}"];    
  };
}
