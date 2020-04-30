{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.share-wayland-socket;
  uid = config.users.users.${cfg.user}.uid;

in {
  options.services.share-wayland-socket = {
    enable = mkEnableOption "share wayland socket";

    user = mkOption {
      description = "User to share socket for";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    systemd.paths.share-wayland-socket = {
      wantedBy = [ "multi-user.target" ];
      before = [ "display-manager.service" ];
      pathConfig.PathExists = "/run/user/${toString uid}/wayland-0";
    };

    systemd.services.share-wayland-socket = {
      path = with pkgs; [ utillinux ];

      script = ''
        touch /tmp/wayland-0 /tmp/wayland-0.lock

        mount -o bind /run/user/${toString uid}/wayland-0 /tmp/wayland-0
        mount -o bind /run/user/${toString uid}/wayland-0.lock /tmp/wayland-0.lock

        chmod g+rw /tmp/wayland-0 /tmp/wayland-0.lock
      '';

      preStop = ''
        umount /tmp/wayland-0 || true
        umount /tmp/wayland-0.lock || true
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
