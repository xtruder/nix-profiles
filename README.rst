============
X-Truder.net
============

Common configuration for x-truder networks

Structure:
----------

- Nix folder contains common nix modules for systems deployed with nixops
- Keys folder contains public keys used in deployment

Creating nixos deployment:
--------------------------

For deploying `nixos <https://nixos.org/nixos/>`_ we use `nixops <https://github.com/nixos/nixops>`_.
To create a new deployment configuration for your new project you have to
first checkout this project to deployments folder and then create new
repository for your new project in same folder.

Then create `logical.nix` and `physical.nix` files where you specify logical
and physical configuration of your network. For example configurations look at
`my home system configurations
<http://www.github.com/offlinehacker/offline.x-truder.net>`_.

When you have created configuration it is advised to first test it in virtualbox.

When you are ready you can deploy your system use::

    $ nixops create ./logical.nix ./physical.nix  --name project.x-truder.net
    $ NIX_PATH=nixpkgs=<path_to_nixpkgs>:deployments=<path_to_deployments> nixops deploy -d project.x-truder.net

Passwords:
----------

You can prehash system passwords using command like::

    $ mkpasswd -m sha-512 $(pass offlinehacker@offline) $(openssl rand -base64 16 | tr -d '+=' | head -c 16)

In nix you can set `hashedPassword`, for more info please reffer to my home
system configuration.

Private data (passwords (that you can't prehash), certificates):
----------------------------------------------------------------

For private data i use `git-encrypt <https://github.com/shadowhand/git-encrypt>`_.
You simply create repo and do::

    $ gitcrypt init

and provide password and salt. Data will automaticly be encrypted when you push
changes to your git server. When you want to decrypt data you simply::

    $ gitcrypt init
    $ git reset --hard HEAD

Building iso image:
-------------------

    $ NIXOS_CONFIG=$(pwd)/iso.nix nix-build '<nixos>' -A config.system.build.isoImage --argstr system x86_64-linux 

Building container:
-------------------

    $ NIXOS_CONFIG=$(pwd)/container.nix nix-build '<nixos>' -A config.system.build.tarball --argstr system x86_64-linux

Building docker auto updatable container:
-----------------------------------------

    $ NIXOS_CONFIG=$(pwd)/autodocker.nix nix-build '<nixpkgs/nixos>' -A config.system.build.dockerImage -I nixpkgs=$HOME/nix/workdirs/master 
    $ cat result/tarball/nixos-system-x86_64-linux.tar.xz | docker import - nixos-autoconfig
