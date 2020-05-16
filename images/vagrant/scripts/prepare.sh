#!/bin/sh -e

# More space for closure
mount -o remount,size=2G /

# Partition disk
cat <<FDISK | fdisk "$disk"
n




a
w

FDISK

# Create filesystem
mkfs.ext4 -j -L nixos "$disk"1

# Mount filesystem
mount LABEL=nixos "/mnt"
