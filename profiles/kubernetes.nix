{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.kubernetes;

  #volumePlugins = pkgs.runCommand "volume-drivers" {} ''
  #  mkdir -p $out/rancher.io~k8s
  #  cp ${pkgs.convoy}/bin/k8s-client $out/rancher.io~k8s/k8s
  #'';

in {
  options.profiles.kubernetes = {
    enable = mkEnableOption "Whether to enable kubernetes profile.";
  };

  config = mkIf cfg.enable {
    services.kubernetes.roles = ["master" "node"];
    services.kubernetes.dns.port = 5555;
    #services.kubernetes.kubelet.volumePluginDir = volumePlugins;
    services.dnsmasq.servers = ["/${config.services.kubernetes.dns.domain}/127.0.0.1#5555"];
    virtualisation.docker.extraOptions = "--iptables=false --ip-masq=false -b cbr0";
    networking.bridges.cbr0.interfaces = [];
    networking.interfaces.cbr0 = {};

    #systemd.services.convoy = {
    #  wantedBy = ["multi-user.target"];
    #  before = ["kubelet.service"];
    #  path = [pkgs.utillinux pkgs.e2fsprogs];
    #  serviceConfig.ExecStart = "${pkgs.convoy}/bin/convoy daemon --drivers devicemapper --driver-opts dm.datadev=/dev/loop7 --driver-opts dm.metadatadev=/dev/loop8";
    #};

    environment.systemPackages = [pkgs.convoy];
  };
}
