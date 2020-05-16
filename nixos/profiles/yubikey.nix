{ pkgs, ... }:

{
  # add yubikey udev packages and usb-modeswitch
  services.udev.packages =
    with pkgs; [ libu2f-host yubikey-personalization usb-modeswitch-data ];

  # add yubikey group, all uses in yubikey group can access yubikey devices
  users.extraGroups.yubikey = {};
}
