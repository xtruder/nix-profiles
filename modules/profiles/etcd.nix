{ config, lib, ... }:

with lib;

let
  cfg = config.profiles.etcd;
in {
  options.profiles.etcd = {
    enable = mkEnableOption "to enable etcd profile.";

    discovery = mkOption {
      description = "Etcd discovery url.";
      type = types.str;
    };
  };

  config = mkIf (cfg.enable)  {
    systemd.services.etcd.serviceConfig.Restart = "always";
    systemd.services.etcd.serviceConfig.RestartSec = "30s";
    services.etcd = {
      advertiseClientUrls = mkDefault ["http://${config.attributes.privateIPv4}:4001"];
      listenClientUrls = mkDefault ["http://${config.attributes.privateIPv4}:4001" "http://127.0.0.1:4001"];
      listenPeerUrls = mkDefault ["http://${config.attributes.privateIPv4}:7001"];
      initialClusterToken = mkDefault config.attributes.projectName;
      initialAdvertisePeerUrls = mkDefault ["http://${config.attributes.privateIPv4}:7001"];
      discovery = cfg.discovery;
    };
  };
}
