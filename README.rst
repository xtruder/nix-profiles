============
X-Truder.net
============

Library of common nix profiles used in various deployments.

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
