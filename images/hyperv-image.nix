{ modulesPath, ... }:

{
  imports = [
    ./hyperv-config.nix
    "${modulesPath}/virtualisation/hyperv-image.nix"
  ];

  hyperv = {
    configFile = ./hyperv-config.nix;
    baseImageSize = 4096;
  };
}
