{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.elm;
in {
  options.roles.dev.elm.enable = mkEnableOption "elm language";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      elmPackages.elm
      yarn

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elm";
          publisher = "sbrink";
          version = "0.18.0";
          sha256 = "10xmsd96rjk1h3sgbabw1h9b8fpma97gl1iq2rydqj389pg3wiac";
        };
      })

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-elm-jump";
          publisher = "joeandaverde";
          version = "0.0.1";
          sha256 = "1l63b7ly8hjb9rrsh0ay5akk0hh48875cv34wpqd248nxdps1bac";
        };
      })
    ];
  };
}
