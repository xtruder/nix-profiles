{ config, ... }:

{
  config.services.dunst = {
    enable = true;

    settings = {
      global = {
        follow = "keyboard";
        markup = "full";
      };

      urgency_low.timeout = 5;
      urgency_normal.timeout = 10;
      urgency_critical.timeout = 15;
    };
  };
}
