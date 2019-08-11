{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.elm;
in {
  options.roles.dev.elm.enable = mkEnableOption "elm role";

  config = mkIf cfg.enable {
    roles.dev.node.enable = mkDefault true;

    programs.vscode.extensions = [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elm";
          publisher = "sbrink";
          version = "0.24.0";
          sha256 = "0864iyxyind7i4vdkdr264ync0wvq1z22km8iz1ybsx6537443aa";
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

    home.packages = with pkgs; [
      elmPackages.elm
    ];
  };
}
