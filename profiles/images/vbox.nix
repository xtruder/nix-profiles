{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.images.vbox;

in {

  imports = [ <nixpkgs/nixos/modules/virtualisation/grow-partition.nix> ];

  options = {
    images.vbox = {
      baseImageSize = mkOption {
        type = types.int;
        default = 10 * 1024;
        description = ''
          The size of the VirtualBox base image in MiB.
        '';
      };

      memorySize = mkOption {
        type = types.int;
        default = 2048;
        description = ''
          The size of the virtualBox memory
        '';
      };
    };
  };

  config = {

    system.build.xtruderOVA = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      name = "nixos-ova-${config.system.nixosLabel}-${pkgs.stdenv.system}";

      inherit pkgs lib config;
      partitioned = true;
      diskSize = cfg.baseImageSize;

      postVM =
        ''
          export HOME=$PWD
          export PATH=${pkgs.virtualbox}/bin:${pkgs.pwgen}/bin:$PATH
          echo "creating VirtualBox pass-through disk wrapper (no copying invovled)..."
          VBoxManage internalcommands createrawvmdk -filename disk.vmdk -rawdisk $diskImage
          echo "creating VirtualBox VM..."
          vmName="NixOS ${config.system.nixosLabel} (${pkgs.stdenv.system})"
          VBoxManage createvm --name "$vmName" --register \
            --ostype ${if pkgs.stdenv.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
          VBoxManage modifyvm "$vmName" \
            --memory ${toString cfg.memorySize} --acpi on --vram 32 \
            ${optionalString (pkgs.stdenv.system == "i686-linux") "--pae on"} \
            --nictype1 virtio --nic1 nat \
            --audiocontroller ac97 --audio alsa \
            --rtcuseutc on \
            --usb on --mouse usbtablet
          VBoxManage storagectl "$vmName" --name SATA --add sata --portcount 4 --bootable on --hostiocache on
          VBoxManage storageattach "$vmName" --storagectl SATA --port 0 --device 0 --type hdd \
            --medium disk.vmdk
          password=$(pwgen 20 -s -1)
          echo "Generated password '$password'"
          echo "verystrongpassword" > pass
          VBoxManage encryptmedium "disk.vmdk" --newpassword pass --cipher "AES-AXTS256-PLAIN64" --newpasswordid "password"
          rm pass
          echo "exporting VirtualBox VM..."
          mkdir -p $out
          fn="$out/nixos-${config.system.nixosLabel}-${pkgs.stdenv.system}.ova"
          VBoxManage export "$vmName" --output "$fn"
          rm -v $diskImage
          mkdir -p $out/nix-support
          echo "file ova $fn" >> $out/nix-support/hydra-build-products
        '';
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
    };

    boot.loader.grub.device = "/dev/sda";

    virtualisation.virtualbox.guest.enable = true;
  };
}

