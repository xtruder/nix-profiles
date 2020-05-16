{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/hyperv-image.nix"
  ];

  hyperv = {
    vmFileName = "nixos.vhdx";
  };
}
