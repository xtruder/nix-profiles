{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xephyr;

  sessionData = config.services.xserver.displayManager.sessionData;

  startwm = pkgs.writeScript "startwm.sh" ''
    #! ${pkgs.bash}/bin/bash

    # get session desktop file
    session_desktop_file=${sessionData.desktops}/share/xsessions/${cfg.sessionName}.desktop

    # parse Exec from desktop file, so we can start session
    session_command=$(grep '^Exec' $session_desktop_file | tail -1 | sed 's/^Exec=//' | sed 's/%.//' | sed 's/^"//g' | sed 's/" *$//g')

    ${sessionData.wrapper} "$session_command"
  '';

in {
  options = {
    services.xephyr = {
      hostUser = mkOption {
        description = "User to use as host";
        type = types.str;
      };

      sessionName = mkOption {
        description = "Name of the session to use";
        type = types.str;
        default = sessionData.autologinSession;
      };

      sessions = mkOption {
        description = "Attribute set of xephyr sessions";
        type = types.attrsOf (types.submodule ({ name, config, ... }: {
          options = {
            user = mkOption {
              description = "User to setup xephyr session for";
              type = types.str;
              default = name;
            };

            displayNumber = mkOption {
              description = "Display number to use for session";
              type = types.int;
            };
          };
        }));
        default = {};
      };
    };
  };

  config = {
    systemd.services = mkMerge (mapAttrsToList (n: s: let
        xsocket = "/tmp/.X11-unix/X${toString s.displayNumber}";
        cookiePath = "/tmp/.X${toString s.displayNumber}-xephyr";
        userHome = config.users.users.${s.user}.home;
        xauthorityPath = "${userHome}/.Xauthority";
        hostUserHome = config.users.users.${cfg.hostUser}.home;
      in {
        "xephyr-daemon-${n}" = {
          description = "Xephyr daemon for ${n}";

          path = with pkgs; [ utillinux acl sudo bash xdotool xorg.xorgserver xorg.xauth xorg.xdpyinfo xorg.setxkbmap xorg.xkbcomp ];
          bindsTo = [ "xephyr-session-${n}.service" ];

          preStart = ''
            # create new Xauthority cookie file and allow host user to read and write
            touch ${cookiePath}
            chown ${cfg.hostUser} ${cookiePath}

            sudo -u ${cfg.hostUser} xauth add :${toString s.displayNumber} . $(mcookie)
            sudo -u ${cfg.hostUser} bash -c 'xauth nlist ":${toString s.displayNumber}" | sed -e "s/^..../ffff/" | xauth -f "${cookiePath}" nmerge -'

            # create user .Xauthority file
            cp ${cookiePath} ${xauthorityPath}
            chown ${s.user} ${xauthorityPath}
          '';

          postStart = ''
            # wait for Xephyr to start
            while ! sudo -u ${s.user} \
                DISPLAY=:${toString s.displayNumber} \
                XAUTHORITY=${xauthorityPath} xdpyinfo >/dev/null 2>&1; do
              echo waiting for Xephyr to start
              sleep 1
            done

            # set same keymap in child as in host
            setxkbmap us -print  | XAUTHORITY=${cookiePath} xkbcomp - :${toString s.displayNumber}

            # set window class
            xdotool search -class Xephyr set_window --name "env: ${n}"
          '';

          environment = {
            DISPLAY = ":0";
            XAUTHORITY = "${hostUserHome}/.Xauthority";
            XKB_BINDIR="${pkgs.xorg.xkbcomp}/bin";
          };

          serviceConfig = {
            User = cfg.hostUser;
            PermissionsStartOnly = true;
            ExecStart = concatStringsSep " " [
              "${pkgs.xorg.xorgserver}/bin/Xephyr :${toString s.displayNumber}"
              "-auth ${cookiePath}"
              "-nolisten tcp"
              "-screen 800x600"
              "-dpi ${toString config.services.xserver.dpi}"
              "-resizeable"
              "-ac"
              "-reset"
            ];
          };
        };

        "xephyr-session-${n}" = {
          description = "Xephyr desktop session for ${n}";
          environment = {
            DISPLAY=":${toString s.displayNumber}";
            XAUTHORITY = "${userHome}/.Xauthority";
          };
          bindsTo = [ "xephyr-daemon-${n}.service" ];
          after = [ "xephyr-daemon-${n}.service" ];
          serviceConfig = {
            ExecStart = startwm;
            User = s.user;
            PAMName = "login";
          };
        };
      }
    ) cfg.sessions);
  };
}
