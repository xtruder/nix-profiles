# utility module to add options for colors that can be reused elsewhere

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.themes;

  colorType = types.str;

  color = (name:
    (mkOption {
      description = "${name} color of palette";
      type = colorType;
    }));

  fromBase16 = { base00, base01, base02, base03, base04, base05, base06, base07
    , base08, base09, base0A, base0B, base0C, base0D, base0E, base0F, ... }:
    mapAttrs (_: v: "#" + v) {
      bg = base00;
      fg = base07;

      gray = base03;
      alt = base02;
      dark = base01;

      red = base08;
      orange = base09;
      yellow = base0A;
      green = base0B;
      cyan = base0C;
      blue = base0D;
      purple = base0E;
    };

  loadYAML = path: importJSON (pkgs.runCommand "yaml-to-json" {
    buildInputs = [ pkgs.remarshal ];
  } "remarshal -i ${path} -if yaml -of json > $out");

in {
  options = {
    themes = {
      colorScheme = mkOption {
        description = "Name of the color scheme to use from base16-unclaimed-schemes package";
        type = types.nullOr types.str;
        default = null;
        example = "irblack";
      };

      colorVariant = mkOption {
        description = "Variant of color scheme to use";
        type = types.enum [ "dark" "light" ];
        default = "dark";
      };

      colors = mkOption {
        description = "Set of colors from which the themes for various applications will be generated";
        type = types.submodule {
          options = {
            bg = color "background";
            fg = color "foreground";
            gray = color "gray";

            alt = color "alternative";
            dark = color "darker";

            blue = color "blue";
            green = color "green";
            red = color "red";
            orange = color "orange";
            yellow = color "yellow";
            cyan = color "cyan";
            purple = color "purple";
          };
        };
      };
    };
  };

  config = {
    # if color scheme file is set, read file and use for colors
    themes.colors = mkIf (cfg.colorScheme != null)
      (fromBase16 (loadYAML "${pkgs.base16-unclaimed-schemes}/${cfg.colorScheme}.yaml"));
  };
}
