{ config, ... }:

{
  config = {
    services.udiskie = {
      enable = true;
      automount = false;
      notify = true;
    };
  };
}
