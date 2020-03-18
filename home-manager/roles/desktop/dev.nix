{ pkgs, ... }:

{
  imports = [
    ../dev.nix
    ./work.nix

    ../../profiles/vscode.nix
  ];

  config = {
    home.packages = with pkgs; [
      # messaging
      zoom-us
    ];
  };
}
