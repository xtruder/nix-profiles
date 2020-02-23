# extra utility function

{ pkgs, lib }:

with lib;

{
  loadYAML = path: importJSON (pkgs.runCommand "yaml-to-json" {
    buildInputs = [ pkgs.remarshal ];
  } "remarshal -i ${path} -if yaml -of json > $out");

  loadPath = imported: source:
    if (builtins.tryEval (builtins.pathExists imported)).value
    then imported else source;
}
