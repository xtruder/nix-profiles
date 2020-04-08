{ config, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  networking.firewall.trustedInterfaces = [ "vboxnet0" "vboxnet1" ];
}
