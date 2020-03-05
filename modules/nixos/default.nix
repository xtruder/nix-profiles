{
  base = ./base.nix;

  environments = {
    base = ./environments/base.nix;
    dev = ./environments/dev.nix;
    work = ./environments/work.nix;
  };

  system = {
    laptop = ./system/laptop.nix;
    vm = ./system/vm.nix;
    iso = ./system/iso.nix;
  };

  # hw profiles
  hw = {
    qemu-vm = ./hw/qemu-vm.nix;
    hyperv-vm = ./hw/hyperv-vm.nix;
    hyperv-vm-gui = ./hw/hyperv-vm-gui.nix;
  };

  # nixos profiles
  profiles = {
    android = ./profiles/android.nix;
    bluetooth = ./profiles/bluetooth.nix;
    docker = ./profiles/docker.nix;
    firmware = ./profiles/firmware.nix;
    libvirt = ./profiles/libvirt.nix;
    network-manager = ./profiles/network-manager.nix;
    pulseaudio = ./profiles/pulseaudio.nix;
    tor = ./profiles/tor.nix;
    xserver = ./profiles/xserver.nix;
    user = ./profiles/user.nix;
    openssh = ./profiles/openssh.nix;
    route-tor = ./profiles/route-tor.nix;
  };

  home-manager = ./home-manager.nix;
}
