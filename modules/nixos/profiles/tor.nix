{ config, ... }:

{
  config = {
    services.tor = {
      enable = true;
      controlPort = 9051;
      client.enable = true;
      client.socksListenAddress = "0.0.0.0:9053";
      client.dns.enable = true;
      client.dns.listenAddress = "0.0.0.0:9053";
      client.transparentProxy.enable = true;
    };

    environment.variables = {
      TOR_SOCKS_PORT = "9050";
      TOR_CONTROL_PORT = "9051";
      TOR_SKIP_LAUNCH = "1";
    };
  };
}
