let
    pkgs = import <nixpkgs> { };

in
    with pkgs.lib;

rec {
    tests.laptop =  with import <nixos/lib/testing.nix> { system = "x86_64-linux"; }; (makeTest ({ pkgs, ... }: {
        nodes = { laptop = (import ./homeops.nix {defPassword = "test";}).laptop; };
        testScript = { nodes }:
          ''
            # Start all machines.
            startAll;
            $laptoplaptop->waitForJob("sshd");
          '';
    }));
}
