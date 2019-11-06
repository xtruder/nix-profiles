{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.roles.dev.nix;
in {
  options.roles.dev.nix.enable = mkEnableOption "nix language";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nixUnstable
      vimPlugins.vim-nix
      dpkg
      nix-prefetch-scripts
      nix-prefetch-github
      bundix
      pypi2nix
      haskellPackages.niv
    ];

    profiles.vscode.extensions = [
      pkgs.vscode-extensions.bbenoist.Nix
    ];

    nix = {
      nixPath = ["nixpkgs=$HOME/projects/nixpkgs"];
      maxJobs = config.attributes.hardware.cpu.cores;
      distributedBuilds = true;
    };

    systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "-/home/${config.users.users.admin.name}/.nix-daemon.env";

    programs.bash.loginShellInit = ''
      function nix-path() {
        readlink -f $(which $1)
      }

      function remove_home_roots() {
        nix-store --gc --print-roots | grep -i /home/offlinehacker | cut -d ' ' -f 1 | xargs rm
      }
    '';
  };
}
