{
  # base module
  module = ./module.nix;

  # nixos hw configuration
  hw = {
    generic = ./hw/generic.nix;
    qemu-vm = ./hw/qemu-vm.nix;
    hyperv-vm = ./hw/hyperv-vm.nix;
    hyperv-vm-gui = ./hw/hyperv-vm-gui.nix;
    virtualbox-vm = ./hw/virtualbox-vm.nix;
  };

  # nixos per system type configuration
  system = {
    laptop = ./system/laptop.nix;
    vm = ./system/vm.nix;
    iso = ./system/iso.nix;
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
    hidpi = ./profiles/hidpi.nix;
    xephyr-session = ./profiles/xephyr-session.nix;
    deploy-key = ./profiles/deploy-key.nix;
  };

  # nixos roles
  roles = {
    base = ./roles/base.nix;
    dev = ./roles/dev.nix;
    work = ./roles/work.nix;
  };
}
