{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.node;
in {
  options.roles.dev.node.enable = mkEnableOption "node language";

  config = mkIf cfg.enable {
    profiles.vscode.extensions = [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "node-module-intellisense";
          publisher = "leizongmin";
          version = "1.5.0";
          sha256 = "062fw12h6v34sridp1hdrr32hfj828s1n14l5bfzvqix38mpn1za";
        };
      })

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "docthis";
          publisher = "joelday";
          version = "0.7.1";
          sha256 = "1154p78vwmi1351m4rads0mdrrkypmzg2s1p4kdq365yp8l9bl67";
        };
      })

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "1.7.2";
          sha256 = "1czq88rb7db8j7xzv1dsx8cp42cbsg7xwbwc68waq5md14wx0ggr";
        };
      })

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-mocha-sidebar";
          publisher = "maty";
          version = "0.20.22";
          sha256 = "114fn8scmp1xxmz56k6z0q0g61liy0flx54n0gxj90df85ygd2ib";
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      nodejs-10_x
      flow
      yarn
    ];

    programs.npm.enable = true;

    environment.variables = {
      PATH = ["$HOME/.npm/bin"];
    };
  };
}
