{ config, pkgs, ... }:
with pkgs.lib;
{
    boot.isContainer = true;
    fileSystems = [ ];

    # Create the tarball
    system.build.tarball = import <nixpkgs/nixos/lib/make-system-tarball.nix> {
      inherit (pkgs) stdenv perl xz pathsFromGraph;

      contents = [];
      storeContents = [
        { object = config.system.build.toplevel + "/init";
          symlink = "/bin/init";
        }
        { object = config.system.build.toplevel;
          symlink = "/run/current-system";
        }
      ];
    };

    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store in the Nix
        # database.
        if [ -f /nix-path-registration ]; then
          ${config.nix.package}/bin/nix-store --load-db < /nix-path-registration &&
          rm /nix-path-registration
        fi

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

    security.pam.services.sshd.startSession = mkOverride 50 false;

    users.extraUsers.root.password = "test";
    users.extraUsers.root.openssh.authorizedKeys.keys = [ (builtins.readFile ../keys/id_rsa.pub) ];

    services.openssh.enable = true;

    networking.hostName = "container";
}
