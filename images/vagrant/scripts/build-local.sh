#!/bin/sh -e

scriptDir=$(dirname "$(readlink -f "$0")")
buildDir="$scriptDir/../build"

tmpdir="$(mktemp -d)"
trap "rm -rf $tmpdir" EXIT

nix build "$scriptDir/../../../#images.$image" -o "$buildDir/$target"

nix-store --export $(nix-store -qR "$buildDir/$target") > "$buildDir/$target.closure"
readlink "$buildDir/$target" > "$buildDir/$target.link"
