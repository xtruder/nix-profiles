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
    google-compute-vm = ./hw/google-compute-vm.nix;
    minimal-part = ./hw/minimal-part.nix;
  };

  # nixos per system type configuration
  environments = {
    base = ./environments/base.nix;
    laptop = ./environments/laptop.nix;
    vm = ./environments/vm.nix;
    iso = ./environments/iso.nix;
    cloud-vm = ./environments/cloud-vm.nix;
    vagrant = ./environments/vagrant.nix;
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
    virtualbox-host = ./profiles/virtualbox-host.nix;
    gnome3 = ./profiles/gnome3.nix;
    sway = ./profiles/sway.nix;
    nix = ./profiles/nix.nix;
    nix-dev = ./profiles/nix-dev.nix;
    yubikey = ./profiles/yubikey.nix;
  };

  # nixos roles
  roles = {
    base = ./roles/base.nix;
    workstation = ./roles/workstation.nix;
    dev-workstation = ./roles/dev-workstation.nix;
    dev-vm = ./roles/dev-vm.nix;
  };
}
