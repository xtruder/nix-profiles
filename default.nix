let
  pkgs = import <nixpkgs> {};

  profiles = import ./modules/module-list.nix;
  options = (import <nixpkgs/nixos/lib/eval-config.nix> {
    modules = profiles;
  }).options;
  optionsList = with pkgs.lib;
    filter (opt: opt.visible && !opt.internal) (optionAttrSetToDocList options);
  # Replace functions by the string <function>
  substFunction = with pkgs.lib; x:
    if builtins.isAttrs x then mapAttrs (name: substFunction) x
    else if builtins.isList x then map substFunction x
    else if builtins.isFunction x then "<function>"
    else x;
  optionsList' = with pkgs.lib; flip map optionsList (opt: opt // {
    declarations = opt.declarations;
  }
  // optionalAttrs (opt ? description) { example = substFunction opt.description; }
  // optionalAttrs (opt ? example) { example = substFunction opt.example; }
  // optionalAttrs (opt ? default) { default = substFunction opt.default; }
  // optionalAttrs (opt ? type) { type = substFunction opt.type; });
  prefixes = ["profiles" "attributes" "roles"];

in with pkgs.lib; {
  inherit profiles;

  options = pkgs.stdenv.mkDerivation {
    name = "options-json";

    buildCommand = ''
      mkdir -p $out
      cp ${pkgs.writeText "options.json" (concatMapStringsSep "\n" (v: ''
        * `${v.name}`:

          ${v.value.description or "No description"}

          **Default:** ${builtins.toJSON v.value.default or "..."}
          **Example:** ${if v.value.description == v.value.example then "..." else (builtins.toJSON v.value.example)}
      '')
        (filter (v: any (p: hasPrefix p v.name) prefixes)
          (map (o: {
              name = o.name;
              value = removeAttrs o ["name" "visible" "internal"];
            }) optionsList'
          )
        )
      )} $out/options.md
    ''; # */

    meta.description = "List of NixOS options in JSON format";
  };

  configurations.dev = import ./configurations/dev.nix;
  configurations.sec = import ./configurations/sec.nix;
}
