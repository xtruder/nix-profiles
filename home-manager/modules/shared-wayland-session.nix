{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.shared-wayland-session;

  importedVariables = config.xsession.importedVariables ++ [
    "WAYLAND_DISPLAY"
  ];

  prepareSession = pkgs.writeScript "prepare-session.sh" ''
    #!${pkgs.runtimeShell} -xe

    PATH=${with pkgs; makeBinPath [ coreutils systemd ]}:$PATH

    export WAYLAND_DISPLAY=wayland-0

    rm $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY || true
    rm $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY.lock || true

    ln -s /tmp/wayland-0 $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY
    ln -s /tmp/wayland-0.lock $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY.lock

    if [ -e "$HOME/.profile" ]; then
      . "$HOME/.profile"
    fi

    systemctl --user import-environment ${toString (unique importedVariables)}
    systemctl --user start graphical-session.target
  '';

  startSockproc = pkgs.writeScript "start-sockproc.sh" ''
    #!${pkgs.runtimeShell} -xe

    if [ -e "$HOME/.profile" ]; then
      . "$HOME/.profile"
    fi

    export PATH=/run/wrappers/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin

    exec ${pkgs.sockproc}/bin/sockproc $XDG_RUNTIME_DIR/sockproc --foreground
  '';

in {
  options.services.shared-wayland-session = {
    enable = mkEnableOption "shared-wayland-session";
  };

  config = mkIf cfg.enable {
    systemd.user.services.sockproc = {
      Unit = {
        Description = "sockproc";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = toString startSockproc;
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

    systemd.user.paths.wayland-active = {
      Unit = {
        Description = "wayland-active";
      };

      Path = {
        PathExists = "/tmp/wayland-0";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };

    systemd.user.services.wayland-active = {
      Unit = {
        Description = "wayland-active";
      };

      Service = {
        ExecStart = toString prepareSession;
      };
    };
  };
}
