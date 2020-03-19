{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firefox;

  ghacks-user-js = import "${pkgs.firefox-ghacks-user-js.override { firefox = cfg.package; }}/user.nix";
  user-js-override = import ./user_js_overrides.nix;
  user-js = ghacks-user-js // user-js-override;

in {
  config = {
    programs.firefox = {
      enable = true;

      extensions = with pkgs.firefox-addons; [
        disabled-add-on-fix-61-65
        https-everywhere
        privacy-badger
        ublock-origin
        vertical-tabs-reloaded
        clearurls
        decentraleyes
        mailvelope
        pushbullet
      ];

      profiles.default = {
        id = 0;
        path = "default";
        userChrome = ''
          ${builtins.readFile ./hide-tabs.css}
        '';
        settings = mkMerge [
          (mapAttrs (_: mkDefault) user-js)
          {
            "browser.startup.homepage" = "https://duckduckgo.com";
          }
        ];
      };

      # firefox scratchpad profile
      profiles.scratchpad = {
        id = 1;
        path = "scratchpad";
        settings = mkMerge [
          user-js
          {
            # always do a clean start
            "browser.sessionstore.resume_from_crash" = false;
          }
        ];
      };
    };

    home.file.".mozilla/native-messaging-hosts/gpgmejson.json".text = builtins.toJSON {
      name = "gpgmejson";
      description = "Integration with GnuPG";
      path = "${pkgs.gpgme.dev}/bin/gpgme-json";
      type = "stdio";
      allowed_extensions = [
        "jid1-AQqSMBYb0a8ADg@jetpack" # mailvelope
      ];
    };
  };
}
