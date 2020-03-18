{ config, lib, ... }:

with lib;

let
  user-env = config.user-env;
  cfg = config.user-env.xephyr;

in {
  options.user-env.xephyr.enable = mkEnableOption "xephy user environments";

  config = mkIf cfg.enable {
    users.users = mapAttrs (n: v: {
      name = v.name;
      home = "/home/${v.name}";
      createHome = true;
      useDefaultShell = true;
      group = "users";
    }) user-env.environments;

    services.xephyr-session = {
      enable = true;
      sessions = mapAttrs (n: v: {
        user = v.name;
      }) user-env.environments;
    };

    home-manager.users = mapAttrs (n: v: { ... }: {
      imports = v.configuration ++ user-env.defaults ++ [
        ../../home-manager/system/user-env.nix
      ];

      # redirect pulseaudio to host if host has pulseaudio enabled
      config.home.file.".config/pulse/client.conf" = mkIf config.hardware.pulseaudio.enable {
        text = ''
          default-server = 127.0.0.1
        '';
      };
    }) user-env.environments;
  };
}
