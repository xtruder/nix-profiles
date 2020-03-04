{ pkgs, ... }:

{
  config = {
    programs.vscode = {
      userSettings = {
        "javascript.validate.enable" = false;
      };
      extensions = with pkgs.my-vscode-extensions; [
        EditorConfig
        json-schema-validator
      ];
    };
  };
}
