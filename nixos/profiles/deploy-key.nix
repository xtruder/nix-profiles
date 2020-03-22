{ lib, ... }:

with lib;

let
  # tries to get recovery ssh key from environment variable or use default
  sshKey =
    let sshKey = builtins.getEnv "deploy_ssh_key"; in
    if sshKey != "" then sshKey
    else null;

in {
  users.users.root.openssh.authorizedKeys.keys = mkIf (sshKey != null) [ sshKey ];
}
