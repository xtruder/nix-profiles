{ config, lib, ... }:

with lib;

{
  imports = [ ../profiles/openssh.nix ];
}
