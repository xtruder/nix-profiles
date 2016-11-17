{ lib, config }:

{
  config = {
    virtualisation.docker.extraOptions = "-s overlay";
    BOOT.kernelModules = ["overlay"];
    networking.firewall.checkReversePath = "loose";
  };
}
