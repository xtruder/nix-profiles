{ lib, vscode-utils }:

with lib;

listToAttrs (map (ext:
  nameValuePair
    ext.name
    (vscode-utils.buildVscodeMarketplaceExtension {mktplcRef = ext;})
) (import ./extensions.nix))
