#! /usr/bin/env nix-shell
#! nix-shell -i bash -p packer -p nixFlakes

scriptDir=$(dirname "$(readlink -f "$0")")
version=$(nix eval --raw "$scriptDir/../../#fullVersion")

echo $version

packer build "$@" --var "version=$version" packer.json
