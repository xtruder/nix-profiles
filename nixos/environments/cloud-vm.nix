{ config, lib, ... }:

with lib;

{
  imports = [
    ../profiles/openssh.nix
    ../profiles/deploy-key.nix
  ];
}
