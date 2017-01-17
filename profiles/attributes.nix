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

    name = mkOption {
      description = "Name of the server";
      type = types.str;
    };

    projectName = mkOption {
      description = "Name of the project";
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

    hashedRootPassword = mkOption {
      description = "root password";
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
    attributes.recoveryKey = mkDefault "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzMleZRroo8Qbe7DxeU39fa2BJSJMSeRjFeYPueGns9p7IIZg2zffRs/qXDBU11KCeC4zSo3JQ3z4ZHPrvRDcWzcfCT7trZLv2VA1CklMy788leTQ0UC3g9/B0/LASUmEP0tNYZn3t5TlvlMK27UHaUM73CfUfWaBMVJL36AgYe406hldEHHYF/K/yR+Z5ZvSDX50QjGv7Ju1aWA2wCJfGYwsZiOUEeqgGLcrO/jB/gAhRP+xOh3VyTnlMDleCcGyklG/UKwOogs50zufwiWqpHTM8ZnH2I0kbVgsA3aUqvBjM/0wAhRbrzdGS4+C3fW73lT78CU46m3EEknRHeFRbi offlinehacker@fc7c600be6cd";
    attributes.hashedRootPassword = mkDefault "$6$zqLu3YEG36cV$5bg5pZrO0.Kkl4KlumwRPxWVgR/iybm7mXPjvFigmWjGQ5o2/oxM/mBUO3ID.dvWRpUJAQHcj.C/tljQ7WgbH0";

    environment.variables.TERMINAL = config.attributes.terminal;

    #networking.nameservers = mkDefault config.attributes.nameservers;
  };
}
