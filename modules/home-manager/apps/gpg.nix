{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.gpg.autoImport;

  isPath = x: builtins.substring 0 1 (toString x) == "/";

  keyserverGPGKeys = filter (k: !(isPath k)) cfg.keys;

  fileGPGKeys = filter (k: isPath k) cfg.keys;

in {
  options.programs.gpg = {
    autoImport = {
      keyserver = mkOption {
        description = "Keyserver to imports keys from";
        type = types.str;
        default = "pgp.mit.edu";
      };

      keys = mkOption {
        description = "List of gpg keys to automatically import";
        type = types.listOf (types.either types.str types.path);
        default = [];
      };
    };
  };

  config = {
    services.gpg-agent =  {
      enable = true;

      # enable usage of ssh with gpg
      enableSshSupport = true;

      # enable extra sockets, useful for gpg agent forwarding
      enableExtraSocket = true;

      # if environment has gui
      pinentryFlavor = if config.xsession.enable then "gtk2" else "curses";
    };

    systemd.user.services.gpg-import-keys = mkIf (cfg.keys != []) {
      Unit = {
        Description = "Auto import gpg keys";
        After = [ "gpg-agent.service" ];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = toString (pkgs.writeScript "import-gpg-keys" ''
          #! ${pkgs.runtimeShell} -el
          ${optionalString (keyserverGPGKeys != []) ''
          ${pkgs.gnupg}/bin/gpg --keyserver pgp.mit.edu --recv-keys ${concatStringsSep " " keyserverGPGKeys}
          ''}
          ${optionalString (fileGPGKeys!= []) ''
          ${pkgs.gnupg}/bin/gpg --import ${concatStringsSep " " fileGPGKeys}
          ''}
        '');
      };

      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
