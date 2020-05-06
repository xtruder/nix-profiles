{ config, ... }:

{
  programs.ssh = {
    enable = true;
  };

  home.file.".ssh/config".text = ''
    Include ~/.ssh/extra_config
  '';
}
