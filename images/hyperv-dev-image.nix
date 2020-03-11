{ modulesPath, ... }:

{
  imports = [
    ./hyperv-dev-config.nix
    "${modulesPath}/virtualisation/hyperv-image.nix"
  ];

  hyperv = {
    configFile = ./hyperv-dev-config.nix;
    baseImageSize = 8192;
  };
}
