#
# Docker container that updates itself
#

{ config, pkgs, ... }:

let
  update_script = ''
    eval $(xargs --null --max-args=1 echo < /proc/1/environ | grep channel)
    eval $(xargs --null --max-args=1 echo < /proc/1/environ | grep package)
    export HOME=/root
    export SYSTEM_PROFILE=$(readlink -f /nix/var/nix/profiles/system)

    if [[ -z "$channel" || -z "$package" ]]; then
      echo "Channel or package not set"
      exit 0
    fi
 
    nix-channel --list | grep deploy || nix-channel --add $channel deploy
    nix-channel --update deploy
    nix-env -iA deploy.$package -p /nix/var/nix/profiles/system

    if [ "$SYSTEM_PROFILE" != "$(readlink -f /nix/var/nix/profiles/system)" ]; then
      echo "switching config to $(readlink -f /nix/var/nix/profiles/system)"
      /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    else
      echo "still on $SYSTEM_PROFILE"
    fi
  '';

in {
  require = [
    <nixpkgs/nixos/modules/virtualisation/docker-image.nix>
  ];

  systemd.services.autoupdate = {
    description = "Auto update docker container";
    script = update_script;
    restartIfChanged = false;
    path = [ pkgs.nix ];
    after = [ "network.target" ];
    wantedBy = ["multi-user.target"];
  };

  systemd.timers.autoupdate = {
    timerConfig = {
      OnUnitInactiveSec = "60s";
      Unit = "autoupdate.service";
    };
    wantedBy = ["autoupdate.service"];
  };

  nix.gc.automatic = true;
}
