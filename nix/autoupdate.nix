{ config, pkgs, lib, ... }:

with lib;


let
  cfg = config.autoupdate;

  update_script = ''
    ${concatMapStringsSep "\n" (package: ''
      dir=$(mktemp -d)
      trap "rm -r $dir" EXIT
      (
        oldlink=$(readlink -f ${cfg.profile})
        curl -L ${package} > $dir/pkg.nixpkg
        nix-install-package $dir/pkg.nixpkg --non-interactive -p $dir/profile
        newlink=$(readlink -e $dir/profile)
        echo "Latest profile: $newlink"
        if [ "$oldlink" != "$newlink" ]; then
          nix-install-package $dir/pkg.nixpkg --non-interactive -p ${cfg.profile}
        else
          echo "Already updated"
        fi
        if [ "$oldlink" != "$newlink" ] || [ ! -f ${cfg.profile}.latest ]; then
          echo "Updating profile link"
          readlink -f $newlink > ${cfg.profile}.latest
        fi
      ) && (
        echo "Update succesfull"
      ) || (
        echo "Update failed"
        exit 1
      )
    '') cfg.packages}
  '';

in {
  options.autoupdate = {
    enable = mkEnableOption "enable autoudpate";

    packages = mkOption {
      description = "List of package urls to auto update.";
      type = types.listOf types.str;
    };

    profile = mkOption {
      description = "Profile path to use for auto updated packages.";
      type = types.path;
      default = "/nix/var/nix/profiles/per-user/${cfg.user}/profile";
    };

    user = mkOption {
      description = "User under which to install.";
      default = "root";
    };

  };

  config = mkIf (cfg.enable) {
    systemd.services.autoupdate = {
      description = "Auto update system packages";
      script = update_script;
      restartIfChanged = false;
      path = [ pkgs.nix pkgs.curl ];
      after = [ "network.target" ];
      environment.HOME = config.users.extraUsers.${cfg.user}.home;
      environment.NIX_REMOTE = "daemon";
      serviceConfig = {
        User = cfg.user;
        Restart = "on-failure";
      };
    };

    systemd.timers.autoupdate = {
      timerConfig = {
        OnUnitInactiveSec = "60s";
        OnBootSec = "1min";
        Unit = "autoupdate.service";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
