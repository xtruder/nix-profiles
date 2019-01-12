{ config, pkgs, lib, ... }:

with lib;

{
  options.profiles.xsuspender = {
    enable = mkEnableOption "xsuspender";
  };

  config = mkIf config.profiles.xsuspender.enable {
    systemd.services.xsuspender = {
      description = "XSuspender service";
      wantedBy = [ "multi-user.target" ];
      environment.DISPLAY = ":0";
      environment.XDG_CONFIG_HOME = "/etc/xdg";
      environment.G_MESSAGES_DEBUG = "all";
      serviceConfig.User = config.users.users.admin.name;
      serviceConfig.ExecStart = "${pkgs.xsuspender}/bin/xsuspender";
    };

    environment.etc."xdg/xsuspender.conf".text = ''
	  [Default]
	  suspend_delay = 5
	  resume_every = 50
	  resume_for = 5
	  send_signals = true
	  only_on_battery = false
	  auto_suspend_on_battery = true
	  downclock_on_battery = 0

	  [Rambox]
	  suspend_delay = 10
	  match_wm_class_contains = rambox
	  suspend_subtree_pattern = .*

	  [Chromium]
	  suspend_delay = 10
	  match_wm_class_contains = chromium-browser
	  suspend_subtree_pattern = chromium
    '';
  };
}
