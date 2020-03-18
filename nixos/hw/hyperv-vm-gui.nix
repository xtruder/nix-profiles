{ ... }:

{
  imports = [ ./hyperv-vm.nix ];

  config = {
    # enable x11 and enchanchedSessionMode on hyperv
    virtualisation.hypervGuest = {
      x11 = true;
      enchanchedSessionMode = true;
    };
  };
}
