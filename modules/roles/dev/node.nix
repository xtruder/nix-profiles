{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.node;
in {
  options.roles.dev.node.enable = mkEnableOption "node language";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs-8_x
      flow
      yarn

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
          version = "1.4.12";
          sha256 = "0ka5ypdz14w3dpmc49i776cirzwl3550klssycvzw813zazxim0f";
        };
      })

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-mocha-sidebar";
          publisher = "maty";
          version = "0.20.11";
          sha256 = "1sil25s4371ps381zck4wlvjdzhnq2x1kdp41k48jigq358qz6sd";
        };
      })
    ];

    programs.npm.enable = true;

    environment.variables = {
      PATH = ["$HOME/.npm/bin"];
    };
  };
}
