{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/hyperv-common.nix"
    ../system/vm.nix
  ];

  virtualisation.hypervGuest.enable = true;
}
