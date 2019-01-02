{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.taskwarrior;

  taskwarriorConfig = ''
    data.location=~/.task
    hook.location=/etc/task/hooks

    # Color theme
    include /var/run/current-system/sw/share/doc/task/rc/${cfg.theme}.theme

    ${cfg.extraConfig}
  '';

  bugwarriorConfig = ''
    [general]
    taskrc = /etc/taskrc

    ${cfg.bugwarrior.extraConfig}
  '';

in {
  options.profiles.taskwarrior = {
    enable = mkOption {
      description = "Whether to enable taskwarrior profile.";
      default = false;
      type = types.bool;
    };

    theme = mkOption {
      description = "Name of the taskwarrior theme";
      type = types.str;
      default = "solarized-dark-256";
    };

    extraConfig = mkOption {
      description = "Taskwarrior extra configuration";
      type = types.lines;
      default = "";
    };

    bugwarrior = {
      enable = mkEnableOption "bugwarrior";

      extraConfig = mkOption {
        description = "Bugwarrior configuration";
        type = types.lines;
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
    with pkgs; [taskwarrior] ++ optional cfg.enable python36Packages.bugwarrior;

    environment.etc."xdg/bugwarrior/bugwarriorrc" = mkIf cfg.bugwarrior.enable {
      text = bugwarriorConfig;
    };

    environment.etc.taskrc.text = taskwarriorConfig;

    environment.variables = {
      BUGWARRIORRC = mkIf cfg.bugwarrior.enable "/etc/xdg/bugwarrior/bugwarriorrc";
      TASKRC = "/etc/taskrc";
    };
  };
}
