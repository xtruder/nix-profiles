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
    programs.gpg.enable = mkDefault true;

    systemd.user.services.gpg-import-keys = mkIf (cfg.keys != []) {
      Unit = {
        Description = "Auto import gpg keys";
        After = [ "gpg-agent.socket" ];
      };

      Service = {
        Type = "oneshot";
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
