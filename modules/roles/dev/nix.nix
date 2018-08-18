{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.nix;
in {
  options.roles.dev.nix.enable = mkEnableOption "nix language";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nixUnstable
      nix-repl
      vimPlugins.vim-nix
      dpkg
      nix-prefetch-scripts
      bundix
      pypi2nix
    ];

    nix = {
      nixPath = ["nixpkgs=$HOME/projects/nixpkgs"];
      maxJobs = config.attributes.cpu.cores;
      distributedBuilds = true;
    };
  };
}
