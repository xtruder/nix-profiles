{ config, ... }: {
  imports = [
    ./nix.nix
    ./go.nix
    ./python.nix
    ./node.nix
    ./devops
    ./ruby.nix
  ];
}
