{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.sentry;
  dbDir = "/var/lib/sentry";

  conf = pkgs.writeText "sentry.conf.py" ''
DATABASES = {
    'default': {
        'ENGINE': '${cfg.dbEngine}',
        'NAME': '${cfg.dbBase}',
        'USER': '${cfg.dbUser}',
        'PASSWORD': '${cfg.dbPass}',
        'HOST': '${cfg.dbHost}',
        'PORT': '${cfg.dbPort}',
        'OPTIONS': {
            'autocommit': True,
        }
    }
}

# No trailing slash!
SENTRY_URL_PREFIX = '${cfg.url}'

# SENTRY_KEY is a unique randomly generated secret key for your server, and it
# acts as a signing token
SENTRY_KEY = '0123456789abcde'

SENTRY_WEB_HOST = '${cfg.host}'
SENTRY_WEB_PORT = ${toString cfg.port}
SENTRY_WEB_OPTIONS = {
    'workers': 3,  # the number of gunicorn workers
    'secure_scheme_headers': {'X-FORWARDED-PROTO': 'https'},  # detect HTTPS mode from X-Forwarded-Proto header
}

SENTRY_REDIS_OPTIONS = {
    'hosts': {
        0: {
            'host': '${cfg.redisHost}',
            'port': ${cfg.redisPort},
        }
    }
}

EMAIL_HOST = '${cfg.smtpHost}'
EMAIL_HOST_PASSWORD = '${cfg.smtpPass}'
EMAIL_HOST_USER = '${cfg.smtpUser}'
EMAIL_PORT = ${cfg.smtpPort}
EMAIL_USE_TLS = ${if cfg.smtpTls then "True" else "False"}

${cfg.extraConfig}
  '';

in {
  ###### interface
  options = {
    services.sentry = rec {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run euganke services.
        '';
      };

      package = mkOption {
        #default = pkgs.euganke;
        description = ''
          Package
        '';
      };

      host = mkOption {
        default = "127.0.0.1";
        description = ''
          Host where euganke will listen
        '';
      };

      port = mkOption {
        default = 9000;
        description = ''
          Port on which sentry will listen
        '';
      };

      url = mkOption {
        description = ''
          Url on which sentry will run
        '';
      };

      dbCreateUser = mkOption {
        default = true;
        description = ''
          Should database user be created
        '';
      };

      dbEngine = mkOption {
        default = "django.db.backends.postgresql_psycopg2";
        description = ''
          Name of database engine
        '';
      };

      dbHost = mkOption {
        default = "localhost";
        description = ''
          Host on which database listens
        '';
      };

      dbPort = mkOption {
        default = "";
        description = ''
          Port on which database listens
        '';
      };

      dbUser = mkOption {
        default = "sentry";
        description = ''
          Database user
        '';
      };

      dbPass= mkOption {
        default = "sentry";
        description = ''
          Database password
        '';
      };

      dbBase = mkOption {
        default = "sentry";
        description = ''
          Database base
        '';
      };

      redisHost = mkOption {
        default = "localhost";
        description = ''
          Host where redis server runs
        '';
      };

      redisPort = mkOption {
        default = "6379";
        description = ''
          Port where redis server runs
        '';
      };

      smtpHost = mkOption {
        default = "localhost";
        description = ''
          Host for smtp server
        '';
      };

      smtpPort = mkOption {
        default = "25";
        description = ''
          Port for smtp server
        '';
      };


      smtpUser = mkOption {
        default = "";
        description = ''
          Username for your user on smtp server
        '';
      };

      smtpPass = mkOption {
        default = "";
        description = ''
          Password for your user on smtp server
        '';
      };

      smtpTls = mkOption {
        default = false;
        description = ''
          Enable tls
        '';
      };

      extraConfig = mkOption {
        default = "";
        description = "Extra configuration";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.sentry = {
      after = [ "network.target" "postgresql.service" "redis.service" ];
      description = "Sentry Server Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/sentry --config=${conf} start
      '';
      serviceConfig.User = "sentry";
      serviceConfig.Group = "sentry";
      preStart = ''
        if ! test -e "${dbDir}/db-created"; then
          ${ if cfg.dbCreateUser then ''
            ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole ${cfg.dbUser} || true
            ${pkgs.postgresql}/bin/dropdb -E utf-8 ${cfg.dbBase} || true
            ${pkgs.postgresql}/bin/createdb --owner ${cfg.dbUser} ${cfg.dbBase}
            ${pkgs.postgresql}/bin/psql -d ${cfg.dbBase} -c "ALTER USER ${cfg.dbUser} WITH PASSWORD '${cfg.dbPass}';"
         '' else "" }

          # populate DB
          ${cfg.package}/bin/sentry --config=${conf} upgrade
          touch "${dbDir}/db-created"
        else
          # run DB migrations
          echo "here"
        fi
      '';
    };

    users.extraUsers.sentry = {
      uid = 12346;
      home = "${dbDir}";
      createHome = true;
      description = "Sentry daemon user";
    };

    users.extraGroups.sentry.gid = 12346;
  };
}
