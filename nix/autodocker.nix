#
# Docker container that updates itself
#

{ config, pkgs, ... }:

let
  update_script = ''
    export $(xargs --null --max-args=1 echo < /proc/1/environ | grep channel)
    export $(xargs --null --max-args=1 echo < /proc/1/environ | grep package)
    export HOME=/root
    nix-channel add $channel deploy
    nix-channel --update deploy
    nix-env -i $package
  '';

in {
  require = [
    <nixpkgs/nixos/modules/virtualisation/docker-image.nix>
  ];

  systemd.services.autoupdate = {
    description = "Auto update docker container";
    script = update_script;
    path = [ pkgs.nix ];
    after = [ "network.target "];
    wantedBy = ["multi-user.target"];
  };

  systemd.timers.autoupdate = {
    timerConfig = {
      OnUnitInactiveSec = "120s";
      Unit = "autoupdate.service";
    };
  };
}
