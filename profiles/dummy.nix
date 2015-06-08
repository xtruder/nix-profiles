{ config, ... }:

{
  systemd.services.dummy = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      while true; do
        echo "i'm alive"
        sleep 1
      done
    '';
  };

  attributes.services.dummy = {
    checks = {
      active_dummy = {
        script = "/var/run/current-system/sw/bin/systemctl is-active dummy";
        interval = "10s";
      };
    };
  };
}
