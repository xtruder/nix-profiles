{ config, lib, ... }: with lib; {
  options.attributes = {
    tags = {
      master = mkEnableOption "Is server a master";
      slave = mkEnableOption "Is server a slave.";
      compute = mkEnableOption "Whether server is a compute node.";
      storage = mkEnableOption "Whether node can be used for storage.";
      graphics = mkEnableOption "Whether node has graphics support.";
      alerting = mkEnableOption "Whether node should have alerting enabled.";
    };

    clusterNodes = mkOption {
      description = "List of nodes to join";
      default = [];
      type = types.listOf types.str;
    };

    publicInterface = mkOption {
      description = "Interface for public network.";
      default = "eth0";
      type = types.str;
    };

    privateInterface = mkOption {
      description = "Interface for private network.";
      default = "eth1";
      type = types.str;
    };

    privateIPv4 = mkOption {
      description = "Private networking address.";
      default = "127.0.0.1";
      type = types.str;
    };

    publicIPv4 = mkOption {
      description = "Public networking address.";
      default = config.networking.publicIPv4;
      type = types.str;
    };

    nameservers = mkOption {
      description = "List of nameservers.";
      default = ["8.8.8.8" "8.8.4.4"];
      type = types.listOf types.str;
    };

    projectName = mkOption {
      description = "Name of the project";
      default = "dummy-project";
      type = types.str;
    };

    domain = mkOption {
      description = "Project domain";
      default = config.attributes.projectName;
      type = types.str;
    };

    recoveryKey = mkOption {
      description = "SSH recovery key";
      default = "";
      type = types.str;
    };

    services = mkOption {
      description = "Definition for service profiles.";
      type = types.attrsOf types.optionSet;
      default = {};
      options = [({name, ...}: {
        options = {
          name = mkOption {
            description = "Service name.";
            type = types.str;
            default = name;
          };

          host = mkOption {
            description = "Host where service listens.";
            type = types.str;
            default = "${config.attributes.privateIPv4}";
          };

          port = mkOption {
            description = "Port Where service listens.";
            type = types.nullOr types.int;
            default = null;
          };

          proxy = {
            enable = mkOption {
              description = "whether to enable http proxy to service.";
              default = false;
              type = types.bool;
            };
          };

          checks = mkOption {
            description = "Definitions for service checks.";
            type = types.attrsOf types.optionSet;
            default = {};
            options = [({name, config, ...}: {
              options = {
                name = mkOption {
                  description = "Check name.";
                  default = name;
                  type = types.str;
                };

                script = mkOption {
                  description = "Check script to run.";
                  type = types.str;
                };

                interval = mkOption {
                  description = "Interval that script is run.";
                  type = types.str;
                  default = "10m";
                };
              };
            })];
          };
        };
      })];
    };
  };

  config = {
    # This is default recovery key for all the servers
    attributes.recoveryKey = mkDefault "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjCcU9GXilOB4cnuw1FkAgn1skXz3MrucFmDowU6kZr recovery@x-truder.net";

    networking.nameservers = mkDefault config.attributes.nameservers;
  };
}
