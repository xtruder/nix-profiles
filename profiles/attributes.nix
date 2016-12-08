{ config, lib, pkgs, ... }: with lib; {
  options.attributes = {
    tags = mkOption {
      description = "Tags associated with node";
      default = [];
      type = types.listOf types.str;
    };

    terminal = mkOption {
      description = "Terminal to use";
      type = types.str;
      default = ''${pkgs.st}/bin/st'';
    };

    termCommand = mkOption {
      description = "Default command to run for terminal";
      type = types.str;
      default = ''${config.attributes.terminal} -c "sucklessterm" -e ${pkgs.tmux}/bin/tmux'';
    };

    clusterNodes = mkOption {
      description = "List of nodes to cluster with";
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
      default = "";
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

    smtp = {
      host = mkOption {
        description = "SMTP host for sending emails";
        default = "smtp.gmail.com";
        type = types.str;
      };

      port = mkOption {
        description = "Port to use for smtp";
        default = 587;
        type = types.int;
      };

      username = mkOption {
        description = "SMTP username";
        type = types.str;
      };

      password = mkOption {
        description = "SMTP password";
        type = types.str;
        default = "";
      };
    };

    emailFrom = mkOption {
      description = "Email to send mails from";
      type = types.str;
      default = "admin@x-truder.net";
    };

    admins = mkOption {
      description = "List of admins";
      type = types.listOf types.optionSet;
      options = {
        email = mkOption {
          description = "Admin email";
          type = types.str;
        };

        notify = mkOption {
          description = "Whether to notify admin about events on the server";
          type = types.bool;
          default = true;
        };

        key = mkOption {
          description = "Admin ssh key";
          type = types.str;
        };
      };
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

          checkFailure = mkOption {
            description = "List of services to check for failure";
            default = [];
            type = types.listOf types.str;
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

    environment.variables.TERMINAL = config.attributes.terminal;

    #networking.nameservers = mkDefault config.attributes.nameservers;
  };
}
