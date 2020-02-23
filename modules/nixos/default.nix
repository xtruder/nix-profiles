{
  base = ./base.nix;

  # exposed system roles
  roles = {
    base = ./roles/base.nix;
    work = ./roles/work.nix;
    dev = ./roles/dev.nix;
    vm = ./roles/vm.nix;
    iso = ./roles/iso.nix;
    laptop = ./roles/laptop.nix;
  };

  # hw profiles
  hw = {
    qemu-vm = ./hw/qemu-vm.nix;
  };

  # application profiles
  apps = {
    docker = ./apps/docker.nix;
    libvirt = ./apps/libvirt.nix;
  };

  home-manager = ./home-manager.nix;
}
