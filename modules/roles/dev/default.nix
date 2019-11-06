{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev;
in {
  options.roles.dev.enable = mkEnableOption "dev role";

  config = mkIf cfg.enable (mkMerge [
    {
      home-manager.users.admin.profiles = {
        dev.enable = true;
      };

      # allow overlayfs in user namespaces
      boot.kernelPatches = [{
        name = "overlayfs-permit-mounts-in-userns.patch";
        patch = pkgs.fetchpatch {
          url = "https://salsa.debian.org/kernel-team/linux/raw/master/debian/patches/debian/overlayfs-permit-mounts-in-userns.patch";
          name = "overlayfs-permit-mounts-in-userns.patch";
          sha256 = "03qzmaq9mwiqbzrx1lvkgkhz3cjv7dky1b4lka3d5q2rwdlyw5qk";
        };
      }];

      boot.extraModprobeConfig = ''
        options overlay permit_mounts_in_userns=1
      '';
    }

    (mkIf (config.profiles.docker.enable) {
      # trust all traffic on docker0
      networking.firewall.trustedInterfaces = ["docker0"];
    })
    
    (mkIf config.profiles.vbox.enable {
      # trust all traffic on vbox interfaces
      networking.firewall.trustedInterfaces = ["vboxnet+"];
     })
  ]);
}
