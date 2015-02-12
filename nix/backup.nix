{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.backup;

in {
  options = {
    profiles.backup = {
      enable = mkOption {
        description = "Whether to enable backup profile.";
        type = types.bool;
        default = false;
      };

      dirPassword = mkOption {
        description = "Bacula director password.";
        type = types.str;
      };

      storagePassword = mkOption {
        description = "Bacula storage password.";
        type = types.str;
      };

      clientCatalogPassword = mkOption {
        description = "Bacula client catalog password";
        type = types.str;
      };

      clientConfig = mkOption {
        description = "Bacula config for client backup.";
        type = types.lines;
      };

      email = mkOption {
        description = "Email address to send notiffications to.";
        type = types.str;
      };
    };
  };

  config = mkIf (cfg.enable) {
    services = {

      # Database for almir and bacula (backups)
      postgresql = {
        enable = mkDefault true;
        package = mkDefault pkgs.postgresql92;
        authentication = ''
          host bacula bacula localhost trust
        '';
        identMap = ''
          # Map bacula and almir user to bacula user
          bacula bacula bacula
          bacula almir bacula
        '';
      };

      # Backups with bacula
      bacula-dir = {
        enable = true;
        name = "bacula-dir";
        password = cfg.dirPassword;
        port = 9101;
        extraConfig = ''
          # =====================
          # GENERAL CONFIGURATION
          # =====================
          # Backup cycle
          Schedule {
            Name = "BackupCycle"
            Run = Level=Full 1st sun at 6:00
            Run = Level=Differential 2nd-5th sun at 6:00
            Run = Level=Incremental mon-sat at 6:00
          }

          # Shared storage for all clients
          Storage {
            Name = File
            SDPort = 9103
            Address = "supervisor";
            Password = "${cfg.storagePassword}"
            Device = FileStorage
            Media Type = File
          }

          # Job defaults
          JobDefs {
            Name = "DefaultJob"
            Type = Backup
            Messages = Standard
            Priority = 10
            FileSet = "DefaultSet"
            Schedule = "BackupCycle"
            Write Bootstrap = "/var/lib/bacula/%c.bsr"
          }

          JobDefs {
            Name = "MongoDbJob"
            Type = Backup
            Messages = Standard
            Priority = 9
            FileSet = "MongoDbSet"
            Schedule = "BackupCycle"
            Write Bootstrap = "/var/lib/bacula/%c.bsr"
            RunBeforeJob = "mongodump -o /tmp/mongodump"
            RunAfterJob  = "rm -r /tmp/mongodump"
          }

          # List of files to be backed up
          FileSet {
            Name = "DefaultSet"
            Include {
              Options {
                signature = SHA1
                compression = GZIP1
                noatime = yes
              }
              File = /etc
            }
          }

          FileSet {
            Name = "MongoDbSet"
            Include {
              Options {
                signature = SHA1
                compression = GZIP1
                noatime = yes
              }
              File = /tmp/mongodump
            }
          }

          # =======
          # CATALOG
          # =======
          Catalog {
            Name = Catalog
            dbdriver = "dbi:postgresql"; dbaddress = 127.0.0.1;
            dbname = "bacula"; dbuser = "bacula";
          }
          Client {
            Name = bacula-fd
            Address = supervisor
            Catalog = Catalog
            Password = "${cfg.clientCatalogPassword}"
          }
          Schedule {
            Name = "CatalogCycle"
            Run = Full sun-sat at 23:10
          }
          FileSet {
            Name = "Catalog Set"
            Include {
              Options {
                signature = MD5
              }
              File = "/var/lib/bacula/bacula.sql"
            }
          }
          Pool {
            Name = CatalogPool
            Label Format = Catalog-
            Pool Type = Backup
            Recycle = yes
            AutoPrune = yes
            Use Volume Once = yes
            Volume Retention = 200 days
            Maximum Volumes = 210
          }
          Job {
            Name = "BackupCatalog"
            JobDefs ="DefaultJob"
            Client = "bacula-fd"
            FileSet="Catalog Set"
            Schedule = "CatalogCycle"
            Level = Full
            Storage = File
            Messages = Standard
            Pool = CatalogPool
            RunBeforeJob = ${pkgs.writeScript "dump-datalog" ''
              #!/run/current-system/sw/bin/bash
              /run/current-system/sw/bin/pg_dump --file /var/lib/bacula/bacula.sql bacula
            ''}
            RunAfterJob  = "rm /var/lib/bacula/bacula.sql"
            Write Bootstrap = "/var/lib/bacula/%n.bsr"
            Priority = 100                   # run after main backups
          }

          # ========
          # CLIENTS
          # ========
          # Each client needs:
          # - Client
          # - Job
          # - 3 Pools (full, differential, incremental)

          # =======
          # RESTORE
          # =======
          # only for placeholding 'Default' pool name
          Pool {
            Name = Default
            Pool Type = Backup
          }
          Job {
            Name = "RestoreFiles"
            Type = Restore
            Client = bacula-fd
            FileSet = "DefaultSet"
            Storage = File
            Pool = Default
            Messages = Standard
            Where = /tmp/bacula-restores
          }

          # ========
          # MESSAGES
          # ========
          # Message delivery for daemon messages (no job).
          Messages {
            Name = Daemon
            mailcommand = "${pkgs.bacula}/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula daemon message\" %r"
            mail = ${cfg.email} = all, !skipped, !info
            console = all, !skipped, !saved
            append = "/var/lib/bacula/bacula.log" = all, !skipped
          }
        '';

        extraDirectorConfig = ''
          Maximum Concurrent Jobs = 1
          Messages = Daemon
        '';

        extraMessagesConfig = ''
          # NOTE! If you send to two email or more email addresses, you will need
          #  to replace the %r in the from field (-f part) with a single valid
          #  email address in both the mailcommand and the operatorcommand.
          #  What this does is, it sets the email address that emails would display
          #  in the FROM field, which is by default the same email as they're being
          #  sent to.  However, if you send email to more than one address, then
          #  you'll have to set the FROM address manually, to a single address.
          #  for example, a 'no-reply@mydomain.com', is better since that tends to
          #  tell (most) people that its coming from an automated source.
          mailcommand = "${pkgs.bacula}/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: %t %e of %c %l\" %r"
          operatorcommand = "${pkgs.bacula}/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: Intervention needed for %j\" %r"
          mail = ${cfg.email} = all, !skipped, !info
          operator = root@localhost = mount
          console = all, !skipped, !saved
          catalog = all, !skipped, !saved
        '';
      };

      bacula-fd = {
        enable = true;
        name = "bacula-fd";
        port = 9102;
        director."bacula-dir" = {
          password = cfg.clientCatalogPassword;
        };
        extraClientConfig = ''
          Maximum Concurrent Jobs = 20
        '';
        extraMessagesConfig = ''
          director = bacula-dir = all, !skipped, !restored
        '';
      };

      bacula-sd = {
        enable = true;
        name = "bacula-sd";
        port = 9103;
        device."FileStorage" = {
          archiveDevice = "/var/backup";
          mediaType = "File";
          extraDeviceConfig = ''
            LabelMedia = yes;
            Random Access = Yes;
            AutomaticMount = yes;
            RemovableMedia = no;
            AlwaysOpen = no;
          '';
        };
        director."bacula-dir" = {
          password = cfg.storagePassword;
        };
        extraMessagesConfig = ''
          director = bacula-dir = all
        '';
        extraStorageConfig = ''
          Maximum Concurrent Jobs = 1
        '';
      };

      # Backup dashbard for bacula
      almir = {
        enable = true;
        prefix = "/almir";
        director_address = "127.0.0.1";
        director_name = "bacula-dir";
        director_password = cfg.dirPassword;
        sqlalchemy_engine_url = "postgresql://bacula@localhost:5432/bacula";
      };

    };

    profiles.nginx.snippets.backup = ''
      location /almir {
        proxy_pass http://127.0.0.1:35000;
        include ${config.profiles.nginx.snippets.proxyDefaults};
      }

      location /console {
        proxy_pass http://127.0.0.1:35000;
        rewrite /console(.*) /almir/console$1  break;
        include ${config.profiles.nginx.snippets.proxyDefaults};
      }
    '';
  };
}
