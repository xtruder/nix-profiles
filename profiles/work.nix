{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.work;

in {
  options.profiles.work = {
    enable = mkOption {
      description = ''
        Whether to enable work profile. Work profile is for all
        instances used for work
      '';
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    # tmux
    programs.tmux.enable = true;
    programs.tmux.newSession = true;
    programs.tmux.extraTmuxConf = builtins.readFile ./tmux.conf;
    programs.tmux.terminal = "screen-256color";

    # chromium
    programs.chromium.enable = true;
    programs.chromium.defaultSearchProviderSearchURL =
      "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
    programs.chromium.defaultSearchProviderSuggestURL =
      "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
    programs.chromium.extensions = [
      "klbibkeccnjlkjkiokjodocebajanakg" # the great suspender
      "chlffgpmiacpedhhbkiomidkjlcfhogd" # pushbullet
      "mbniclmhobmnbdlbpiphghaielnnpgdp" # lightshot
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
    ];
  };
}
