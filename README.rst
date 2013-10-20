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
create a new repository, and then include this repository with git subtree::

    $ git remote add -f x-truder.net https://www.github.com/offlinehacker/x-truder.net.git
    $ git subtree add --prefix x-truder.net x-truder.net master --squash

Then create `logical.nix` and `physical.nix` files where you specify logical
and physical configuration of your network. For example configurations look at
`my home system configurations
<http://www.github.com/offlinehacker/offline.x-truder.net>`_.

When you have created configuration it is advised to first test it on some
continous integration system like `hydra <https://github.com/nixos/hydra>`_.

When you are ready you can deploy your system use::

    $ nixops create ./logical.nix ./physical.nix  --name project.x-truder.net
    $ NIX_PATH=<PATH_TO_NIX> nixops deploy -d project.x-truder.net

Private data (password, certificates,...):
------------------------------------------

For private data i use `git-encrypt <https://github.com/shadowhand/git-encrypt>`.
You simply create repo and do::

    $ gitcrypt init

and provide password and salt. Data will automaticly be encrypted when you push
changes to your git server. When you want to decrypt data you simply::

    $ gitcrypt init
    $ git reset --hard HEAD
