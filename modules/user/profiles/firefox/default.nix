{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.firefox;

in {
  options.profiles.firefox = {
    enable = mkEnableOption "firefxo profile";

    startup = {
      pages = mkOption {
        description = "List of startup pages";
        type = types.listOf types.str;
        default = [];
      };

      startOnBoot = mkOption {
        description = "Whether to start firefox on boot";
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
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
        path = "wj54vnqp.default";
        userChrome = ''
          ${builtins.readFile ./hide-tabs.css}
        '';
        settings = mkMerge [
          (import ./ff-security.nix)
          {
            "browser.statup.homepage" = "https://searx.be";
          }
        ];
      };

      profiles.scratchpad = {
        id = 1;
        path = "scratchpad";
        userChrome = ''
          ${builtins.readFile ./hide-tabs.css}
          ${builtins.readFile ./auto-hide.css}
        '';
        settings = {
          # always do a clean start
          "browser.sessionstore.resume_from_crash" = false;
        };
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
