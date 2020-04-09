{ config, ... }:

let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/a21c2fa3ea2b88e698db6fc151d9c7259ae14d96.tar.gz";
    sha256 = "1z3kxlbz6bqx1dlagcazg04vhk67r8byihzf959c3m0laf2a1w7y";
  }) { system = "x86_64-linux"; };

  chrpkgsBall = builtins.fetchTarball {
    url = "https://github.com/colemickens/nixpkgs-chromium/archive/master.tar.gz";
    sha256 = "1dimj4blhlgxss0xjl0ppdw3nfpmq5hr6rm77zgpib5hphf54r1n";
  };
  chromium = pkgs.callPackage "${chrpkgsBall}/pkgs/chromium-git" { };
in {
  programs.chromium = {
    enable = true;
  };

  nixpkgs.config.enableWideWine = true;
}
