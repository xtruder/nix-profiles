{ config, ... }:

{
  imports = [ ./base.nix ];

  config = {
    services.gpg-agent.pinentryFlavor = "gnome3";
  };
}
