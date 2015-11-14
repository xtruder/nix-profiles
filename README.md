# X-Truder.net

Library of common nix profiles used in various deployments.

## Including profiles in your nixos configuration

There are two ways to include these modules in your nixos configuration. One is
with using fetchFromGitHub and the other is cloning modules and including them

- Using fetchFromGitHub and including profiles:

```
{ pkgs, ... }:

let
  x-truder = fetchFromGitHub {
    src = "git@github.com:offlinehacker/x-truder.net.git";
    rev = "08386f7702d2ed62ece017048f1fc815b62ee8b2";
    sha256 = "";
  };
in {
  require = include "${x-truder}/profiles/module-list.nix";
}
```

- Directly including profiles:

```
{ ... }:

{
  require = import <x-truder.net/profiles/module-list.nix>;
}
```

Make sure x-truder.net is set in `NIX_PATH`

## Defined options

Look into [options.md](options.md) file.
