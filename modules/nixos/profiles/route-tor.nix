# profile that configures system to route all trafic through tor

{ lib, ... }:

with lib;

let
  whitelistAddresses = [
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

in {
  imports = [ ./tor.nix ];

  config = {
    networking.firewall.extraCommands = ''
      #*nat PREROUTING (For middlebox)
      iptables -t nat -A PREROUTING -d 10.192.0.0/10  -p tcp --syn -j REDIRECT --to-ports 9040
      iptables -t nat -A PREROUTING -p udp --dport 5353 -j REDIRECT --to-ports 9053
      iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 9053
      iptables -t nat -A PREROUTING -p tcp --dport 5353 -j REDIRECT --to-ports 9053
      iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 9053

      #*nat OUTPUT (For local redirection)
      iptables -t nat -A OUTPUT -d 10.192.0.0/10 -p tcp --syn -j REDIRECT --to-ports 9040
      iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
      iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 9053
      iptables -t nat -A OUTPUT -m owner --uid-owner tor -j RETURN
      iptables -t nat -A OUTPUT -o lo -j RETURN

      # whitelist addresses
      ${concatMapStrings (address: ''
        iptables -t nat -A OUTPUT -d ${address} -j RETURN
      '') whitelistAddresses}

      #redirect all other pre-routing and output to Tor
      iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
    '';

  };
}
