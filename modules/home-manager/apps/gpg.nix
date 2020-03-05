{ config, ... }:

{
  config.services.gpg-agent =  {
    enable = true;

    # enable usage of ssh with gpg
    enableSshSupport = true;

    # enable extra sockets, useful for gpg agent forwarding
    enableExtraSocket = true;

    # if environment has gui
    pinentryFlavor = if config.xsession.enable then "gtk2" else "curses";
  };
}
