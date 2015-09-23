{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.elasticsearch;
in {
  options.profiles.elasticsearch = {
    enable = mkOption {
      description = "Whether to enable elasticsearch.";
      type = types.bool;
      default = false;
    };

    keystore = {
      password = mkOption {
        description = "Secret password for keystore";
        type = types.str;
      };

      path = mkOption {
        description = "Path for keystore";
        type = types.path;
      };
    };

    truststore = {
      password = mkOption {
        description = "Secret password for keystore";
        type = types.str;
      };

      path = mkOption {
        description = "Path to trustore";
        type = types.path;
      };
    };

    kibana = {
      enable = mkOption {
        description = "Wheter to enable kibana.";
        type = types.bool;
        default = config.attributes.tags.master;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    services = {
      elasticsearch.enable = mkDefault true;
      elasticsearch.host = "0.0.0.0";
      elasticsearch.plugins = [
        pkgs.elasticsearchPlugins.search_guard
      ];
      elasticsearch.cluster_name = config.attributes.projectName;
      elasticsearch.extraConf = ''
        searchguard.key_path: /var/lib/elasticsearch/
        network.publish_host: ${config.attributes.privateIPv4}
      '';

        #searchguard.ssl.transport.node.enabled: true

        #searchguard.ssl.transport.node.keystore_type: JKS
        #searchguard.ssl.transport.node.keystore_filepath: ${cfg.keystore.path}
        #searchguard.ssl.transport.node.keystore_password: ${cfg.keystore.password}
        #searchguard.ssl.transport.node.enforce_clientauth: true

        #searchguard.ssl.transport.http.truststore_type: JKS
        #searchguard.ssl.transport.node.truststore_filepath: ${cfg.truststore.path}
        #searchguard.ssl.transport.node.truststore_password: ${cfg.truststore.password}

        #searchguard.ssl.transport.node.encforce_hostname_verification: true
        #searchguard.ssl.transport.node.encforce_hostname_verification.resolve_host_name: true

      };
    }
    (mkIf cfg.kibana.enable {
      services.kibana.enable = true;
      services.kibana.host = config.attributes.privateIPv4;

      attributes.services.kibana = {
        host = config.attributes.privateIPv4;
        port = 5601;
        proxy.enable = true;
      };
    })
  ]);
}
