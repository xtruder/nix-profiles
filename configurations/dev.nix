{ config, pkgs, ... }:

{
  imports = (import ./../default.nix).profiles;

  profiles.dev.enable = true;
  profiles.kubernetes.enable = true;
  profiles.headless.enable = true;

  # Add me as admin user
  users.extraUsers.offlinehacker = {
    description = "me, the admin ";
    home = "/home/offlinehacker";
    createHome = true;
    useDefaultShell = true;
    extraGroups = ["wheel" "users" "pulse" "developers" "adbusers"];
    group = "users";
    passwordFile = toString (pkgs.writeText "pass" "$6$/28CyNtMzJPPzWbD$R2QQmrS0noq7wA2rRbgtkSKh12X9psvYe562iGtVL15B3tgqVVx46QUe19sxXbnCbT2sqctMf3BSmWgKam9MV0");
    shell = pkgs.bashInteractive + "/bin/bash";
  };

  users.extraUsers.deploy = {
    description = "me, the admin";
    home = "/home/deploy";
    createHome = true;
    useDefaultShell = true;
    extraGroups = ["wheel" "developers"];
    group = "users";
    shell = pkgs.bashInteractive + "/bin/bash";
  };

  users.extraGroups.developers.gid = 1001;

  attributes.projectName = "offline.x-truder.net";
  attributes.name = "dev";

  services.kubernetes.dns.domain = "dev.offline.x-truder.net";
  virtualisation.virtualbox.host.addNetworkInterface = false;

  environment.systemPackages = [
    pkgs.chromium
    pkgs.bundle.dev
    pkgs.bundle.vim
    pkgs.bundle.node
    pkgs.bundle.go
    pkgs.bundle.nix
    pkgs.bundle.admin
    pkgs.bundle.kubernetes
    pkgs.bundle.python3
    pkgs.pachyderm
    pkgs.atom
    pkgs.vscode
  ];

  fileSystems.virtualbox = {
    device = "/dev/sdb";
    autoFormat = true;
    fsType = "ext4";
    mountPoint = "/home/offlinehacker/projects";
  };

  fileSystems.projects-deploy = {
    device = "/dev/sdb";
    mountPoint = "/home/deploy/projects";
  };
}
