#!/bin/sh -e

packer_http=$(cat .packer_http)

# Partition disk
cat <<FDISK | fdisk "$disk"
n




a
w

FDISK

# Create filesystem
mkfs.ext4 -j -L nixos "$disk"

# Mount filesystem
mount LABEL=nixos /mnt

# A place to drop temporary stuff.
tmpdir="$(mktemp -d -p $mountPoint)"
trap "rm -rf $tmpdir" EXIT

# store temporary files on target filesystem by default
export TMPDIR=${TMPDIR:-$tmpdir}

sub="auto?trusted=1"

# Build system
outLink="$tmpdir/system"
nix-build --out-link "$outLink" --show-trace --store "/mnt" --extra-substituters "$sub" \
    "$source" -A images.$image

# Do nixos install with built system
nixos-install --system "$outLink" --no-channel-copy --show-trace --no-root-passwd

# Cleanup
curl "$packer_http/postinstall.sh" | nixos-enter
