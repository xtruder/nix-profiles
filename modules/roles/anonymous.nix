{ config, lib, ... }:

with lib;

let
  cfg = config.roles.anonymous;
in {
  options.roles.anonymous = {
    enable = mkEnableOption "anonymous role";

    routeTraffic = mkOption {
      description = "Whether route traffic through tor";
      default = true;
      type = types.bool;
    };

    whitelistAddresses = mkOption {
      type = types.listOf types.str;
      description = "List of adddresses to whitelist";
      default = [
        #LAN destinations that shouldn't be routed through Tor
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"

        #Other IANA reserved blocks (These are not processed by tor and dropped by default)
        "0.0.0.0/8"
        "100.64.0.0/10"
        "169.254.0.0/16"
        "192.0.0.0/24"
        "192.0.2.0/24"
        "192.88.99.0/24"
        "198.18.0.0/15"
        "198.51.100.0/24"
        "203.0.113.0/24"
        "224.0.0.0/3"
      ];
    };
  };

  config = mkIf cfg.enable {
    services.tor = {
      enable = true;
      controlPort = 9051;
      client.enable = true;
    };

    networking.firewall.extraCommands = mkIf cfg.routeTraffic ''
      #*nat PREROUTING (For middlebox)
      iptables -t nat -A PREROUTING -d 10.192.0.0/10  -p tcp --syn -j REDIRECT --to-ports 9040
      iptables -t nat -A PREROUTING -p udp --dport 5353 -j REDIRECT --to-ports 9053
      iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 9053

      #*nat OUTPUT (For local redirection)
      iptables -t nat -A OUTPUT -d 10.192.0.0/10 -p tcp --syn -j REDIRECT --to-ports 9040
      iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
      iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 9053
      iptables -t nat -A OUTPUT -m owner --uid-owner tor -j RETURN
      iptables -t nat -A OUTPUT -o lo -j RETURN

      #whitelist addresses
      ${concatMapStrings (address: ''
        iptables -t nat -A OUTPUT -d ${address} -j RETURN
      '') cfg.whitelistAddresses}

      #redirect all other pre-routing and output to Tor
      iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
    '';
  };
}
