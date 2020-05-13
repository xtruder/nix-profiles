{ config, ... }:

{
	fileSystems."/" = {
		device = "/dev/disk/by-label/nixos";
		autoResize = true;
		fsType = "ext4";
	};

	boot.loader.grub.device = "/dev/sda";
}
