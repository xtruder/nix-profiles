#! @shell@

set -e
shopt -s nullglob

export PATH=@path@:$PATH

function show_help() {
    echo "nixos-init: -r <repo> -i -p"
}

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
repo=""
init_repo=0
paste=0

while getopts "h?r:ip" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    r)  repo=$OPTARG
        ;;
    i)  init_repo=1
        ;;
    p)  paste=1
        ;;
    esac
done

shift $((OPTIND-1))

if [ -z "$repo"]; then
    repo="${1:-}"
fi

if [ -z "$repo" ]; then
    echo "Repo most not be empty"
    exit 1
fi

echo "Using repo: $repo"

if [[ "$paste" == 1 ]]; then
    echo -n "Pasting public key to termbin.com: "
    nc $(cat /etc/ssh/ssh_host_ed25519_key.pub) | nc termbin.com 9999
    echo
    read -n 1 -s -r -p "Press any key when ssh key is deployed to github"
fi

echo "Configuraing git"
git config --global user.name "X-Truder Deploy User"
git config --global user.email "deploy@x-truder.net"
git config --global.sshCommand "ssh -i /etc/ssh/ssh_host_ed25519_key"

if [[ "$init_repo" == 1 ]]; then
    echo "Creating initial repo"

    (
        cd /etc/nixos
        git init
        git remote add origin "$repo"
        git add configuration.nix
        git commit -m "first commit"
        git push origin master
    )
else
    echo "Cloning configuration repo"

    (
        if [ -d /etc/nixos ]; then
            echo "Backing up old /etc/nixos"
            mv /etc/nixos /etc/nixos.bak
        fi

        cd /etc
        git clone "$repo" nixos
    )
fi

echo "Setup complete, edit your /etc/nixos/configuration.nix and do \"nixos-rebuild switch\""
