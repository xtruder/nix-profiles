{ config, lib, pkgs, nodes, ... }: with lib;

let
  cfg = config.profiles.kubernetes;

  kubehub = pkgs.goPackages.buildGoPackage rec {
    name = "kubehub-v${version}";
    version = "0.1.3";
    goPackagePath = "github.com/GateHubNet/kubehub";
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";

    src = pkgs.fetchFromGitHub {
      repo = "kubehub";
      owner = "GateHubNet";
      rev = "v${version}";
      sha256 = "11b2nd4qg25gh48xry23fv87s0pg2vskgpdiii78dzya83wanv5j";
    };

    subPackages = [ "./" ];
  };

in {
  options.profiles.kubernetes = {
    enable = mkEnableOption "Whether to enable kubernetes profile.";

    master = mkOption {
      description = "Wheter node is master";
      default = false;
      type = types.bool;
    };

    node = mkOption {
      description = "Wheter node is a compute node";
      default = config.attributes.tags.compute;
      type = types.bool;
    };

    tokens = mkOption {
      description = "Attribute set of username and passwords";
      default = {};
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    services = {
      nodeDockerRegistry.enable = mkDefault true;
      nodeDockerRegistry.port = mkDefault 5000;

      kubernetes = {
        roles =
          (optionals cfg.master ["master"]) ++
          (optionals cfg.node ["node"]);
        dockerCfg = ''{"master:5000":{}}'';

        # If running a master join all compute nodes
        controllerManager.machines =
          map (n: n.config.attributes.privateIPv4)
          (filter (n: n.config.attributes.tags.compute) (attrValues nodes));
        apiserver = {
          address = "0.0.0.0";
          tokenAuth = cfg.tokens;
        };

        kubelet = {
          hostname = config.attributes.privateIPv4;
          clusterDns = config.attributes.privateIPv4;
          clusterDomain = "kubernetes.io";
        };

        reverseProxy.enable = true;
        logging.enable = true;
      };

      #skydns.domain = "kubernetes.io";
    };

    virtualisation.docker.extraOptions =
      ''--iptables=false --ip-masq=false -b br0 --log-level="warn"'';
  } (mkIf cfg.master {
    profiles.nginx.upstreams = {
      kubernetes = { servers = [ "127.0.0.1:8080"]; };
      kubehub = { servers = [ "127.0.0.1:8081" ]; };
      docker-registry = { servers = [ "127.0.0.1:5000"]; };
    };

    profiles.nginx.snippets.kubernetes = ''
      location / {
        proxy_pass http://kubernetes;
        include ${config.profiles.nginx.snippets.proxy};
      }

      location /kubehub {
        proxy_pass http://kubehub;
        include ${config.profiles.nginx.snippets.proxy};
        rewrite /kubehub(.*) $1  break;
      }
    '';

    profiles.nginx.snippets.docker-registry = ''
      location / {
        proxy_pass http://docker-registry;
        proxy_set_header Host       $http_host;   # required for Docker client sake
        proxy_set_header X-Real-IP  $remote_addr; # pass on real client IP

        client_max_body_size 0; # disable any limits to avoid HTTP 413 for large image uploads

        # required to avoid HTTP 411: see Issue #1486 (https://github.com/dotcloud/docker/issues/1486)
        chunked_transfer_encoding on;
      }
    '';

    systemd.services.kubehub = {
      description = "Kubehub Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      preStart = "touch /var/lib/kubernetes/kubehub.yaml";
      serviceConfig.ExecStart = "${kubehub}/bin/kubehub -c /var/lib/kubernetes/kubehub.yaml --log_level=debug";
      serviceConfig.User = "kubernetes";
    };
  })]);
}
