# profile for single user system

{ config, ... }:

{
  config = {
    # create default user
    users.users.user = {
      name = "user";
      description = "System default user";
      home = "/home/user";
      createHome = true;
      useDefaultShell = true;
      extraGroups = ["wheel"];
      group = "users";
    };

    security.sudo.wheelNeedsPassword = false;
  };
}
