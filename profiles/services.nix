{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.monitoring;
  attrs = config.attributes;

in {

  options.attributes.
}
