{ config, lib, ... }:

with lib;

let
  cfg = config.recovery;

in {
  options.recovery = {
    passwordHash = mkOption {
      description = "Recovery password";
      type = types.str;
      default = "$5$jVNwQm2UlWfF$jdKdRk8JB2cNafMdQOx97EmKdttz6Hr1cNWGaiXfEcC";
    };

    sshKey = mkOption {
      description = "SSH recovery public key";
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = {
    users.users = {
      # recovery user is used for system recovery
      recovery = {
        # password for logging into root
        hashedPassword = cfg.passwordHash;

        # add deploy ssh key
        openssh.authorizedKeys.keys = mkIf (cfg.sshKey != null) [
          cfg.sshKey
        ];

        home = "/home/recovery";
        createHome = true;
        useDefaultShell = true;
        extraGroups = ["wheel"];
        group = "users";
      };
    };


  };
}
