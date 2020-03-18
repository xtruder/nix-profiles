{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/hyperv-image.nix"
    ../system/vm.nix
  ];

  hyperv = {
    vmFileName = "nixos.vhdx";
  };
}
