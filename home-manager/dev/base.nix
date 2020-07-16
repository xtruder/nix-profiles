{ pkgs, config, ... }:

{
  config = {
    services.code-server.extensions = config.programs.vscode.extensions;

    programs.vscode = {
      userSettings = {
        "javascript.validate.enable" = false;
      };
      extensions = with pkgs.my-vscode-extensions; [
        vscode-yaml
        EditorConfig
        json-schema-validator

        vim
        path-autocomplete
        all-autocomplete
        vscode-direnv

        # utils
        openssl.bin
      ];
    };
  };
}
