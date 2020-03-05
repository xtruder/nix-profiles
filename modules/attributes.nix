{ config, lib, pkgs, ... }:

with lib;

{
  options.attributes = {
    name = mkOption {
      description = "Name of the server";
      type = types.str;
      default = "nixos";
    };

    project = mkOption {
      description = "Name of the project";
      type = types.str;
      default = "x-truder.net";
    };

    networking = {
      primaryInterface = mkOption {
        description = "Primary network interface";
        type = types.str;
      };
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

    hardware = {
      cpu = {
        cores = mkOption {
          description = "Number of CPU cores";
          type = types.int;
        };
      };

      hasBattery = mkOption {
        description = "Whether system has a battery";
        type = types.bool;
        default = false;
      };

      hasBluetooth = mkOption {
        description = "Whether system has bluetooth";
        type = types.bool;
        default = false;
      };

      isVM = mkOption {
        description = "Whether system is a virtual machine";
        type = types.bool;
        default = false;
      };

      isContainer = mkOption {
        description = "Whether system is a container";
        type = types.bool;
        default = false;
      };
    };

    services = {
      enable = mkOption {
        description = "List of required enabled system features";
        type = types.listOf types.str;
        default = [];
      };
    };
  };
}
