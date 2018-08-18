{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.dunst;

  mkAllDefault = value: priority:
    if isAttrs value
    then mapAttrs (n: v: mkAllDefault v priority) value

    else if isList value
    then map (v: mkAllDefault v priority) value

    else mkOverride priority value;

  configurationFile = pkgs.runCommand "dunst-json-to-toml" {
    buildInputs = [pkgs.remarshal];
  } ''json2toml -i ${pkgs.writeText "to-json" (builtins.toJSON cfg.configuration)} -o $out'';
in {
  options.profiles.dunst = {
    enable = mkOption {
      description = "Whether to enable dunst profile.";
      default = false;
      type = types.bool;
    };

    configuration = mkOption {
      description = "Extra dunst config";
      type = mkOptionType {
				name = "deepAttrs";
				description = "deep attribute set";
				check = isAttrs;
				merge = loc: foldl' (res: def: recursiveUpdate res def.value) {};
			};
      default = {};
    };
  };

  config = {
    profiles.dunst.configuration = {
      global = {
        markup = "yes";
        format = "<b>%s</b>\n%b";
        sort = "yes";
        indicate_hidden = "yes";
        bounce_freq = 0;
        show_age_threshold = 60;
        word_wrap = "yes";
        ignore_newline = "no";
        idle_threshold = 120;
        monitor = 0;
        follow = "keyboard";
        sticky_history = "yes";
        startup_notification = false;
        dmenu = "rofi -dmenu -p dunst";
        browser = "chromium -new-tab";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
			urgency_low.timeout = 5;
			urgency_normal.timeout = 20;
      urgency_critical.timeout = 20;
    };
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.dunst}/bin/dunst -config ${configurationFile} &
    '';
  };
}
