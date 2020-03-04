{ pkgs, ... }:

{
  imports = [
    ../dev.nix
    ./work.nix

    ../../apps/vscode.nix
  ];

  config = {
    home.packages = with pkgs; [
      # messaging
      zoom-us
    ];
  };
}
