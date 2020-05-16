{ config, lib, ... }:

with lib;

let
  cfg = config.system.recovery;

  # tries to get recovery password hash from environment variable
  recoveryPasswordHash =
    let passwordHash = builtins.getEnv "recovery_password_hash"; in
    if passwordHash != ""
    then passwordHash
    else "$5$jVNwQm2UlWfF$jdKdRk8JB2cNafMdQOx97EmKdttz6Hr1cNWGaiXfEcC"; # recovery

  # tries to get recovery ssh key from environment variable or use default
  recoverySshKey =
    let sshKey = builtins.getEnv "recovery_ssh_key"; in
    if sshKey != "" then sshKey
    else null;

in {
  options.system.recovery = {
    passwordHash = mkOption {
      description = "Recovery password";
      type = types.str;
      default = recoveryPasswordHash;
    };

    sshKey = mkOption {
      description = "SSH recovery public key";
      type = types.nullOr types.str;
      default = recoverySshKey;
    };
  };

  config = {
    users.users = {
      # recovery user is used for system recovery
      recovery = {
        # password for logging into root
        hashedPassword = cfg.passwordHash;

        uid = 1100;

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
