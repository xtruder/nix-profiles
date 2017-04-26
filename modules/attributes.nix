{ config, lib, pkgs, ... }:

with lib;
  
{
  options.attributes = {
    name = mkOption {
      description = "Name of the server";
      type = types.str;
    };

    projectName = mkOption {
      description = "Name of the project";
      type = types.str;
    };

    cpu = {
      cores = mkOption {
        description = "Number of CPU cores";
        type = types.int;
      };
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

    recoveryKey = mkOption {
      description = "SSH recovery key";
      type = types.str;
    };

    recoveryPassword = mkOption {
      description = "Recovery password";
      type = types.str;
    };

    admin = {
      email = mkOption {
        description = "Admin email";
        type = types.str;
      };

      fullname = mkOption {
        description = "Admin fullname";
        type = types.str;
      };
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

      from = mkOption {
        description = "Email to send mails from";
        type = types.str;
      };
    };
  };
}
