#!/bin/sh -e

outLink=$(cat "/nixos.link")

nix-store --store "/mnt" --import < "/nixos.closure"

# Do nixos install with built system
nixos-install --system "$outLink" --no-channel-copy --show-trace --no-root-passwd
