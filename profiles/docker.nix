{ lib, config }:

{
  config = {
    virtualisation.docker.extraOptions = "-s overlay";
    boot.kernelModules = [ "overlay" ];
  };
}
