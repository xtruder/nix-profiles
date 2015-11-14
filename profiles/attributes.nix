{ config, lib, nodes, ... }: with lib; {
  options.attributes = {
    tags = mkOption {
      description = "Tags associated with node";
      default = [];
      type = types.listOf types.str;
    };

    clusterNodes = mkOption {
      description = "List of nodes to cluster with";
      default = attrNames (
        filterAttrs (n: node: elem "cluster" node.config.attributes.tags) nodes
      );
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

    checks = mkOption {
      description = "System wide checks.";
      type = types.attrsOf types.optionSet;
      default = {};
      options = [({name, ...}: {
        options = {
          name = mkOption {
            description = "Service name.";
            type = types.str;
            default = name;
          };
        };
      })];
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
    attributes.recoveryKey = mkDefault "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaE19d8gInLMqM6m35aiPaf1P+3K1aR+k1WSogyhsYHM6heAvOguB88ECHghDPsKn4lb4ab5OuI9hpek5gE1sBzTdd5QgSPd175F47W8NpBzujQIOrQ2mkhTmrMA3k4z9RYYrIrooHqxdZ+4H5Gxxm5ydkfrmOHxj0Tl6nE50SdQWPl++1AvXD6BzUhbptuKGOFIrPnatmFwG2GAffPKltQKi42unrpo5ajb5S7R3bofzhL7y3A/4KKRo2q+VBA9ZAZ9oELDdn7tkq0JlzM7kG241rG1QUbvvwQFJMtrLKdW17bdNyn8CuFWlPEFyX2+ybn74CusV5zYWZnNJwUf67 jakahudoklin@x-truder.net";

    #networking.nameservers = mkDefault config.attributes.nameservers;
  };
}
