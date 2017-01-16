let
  pkgs = import <nixpkgs> {};
  symlinkPlugins = pkgs.runCommand "symlinkPlugins" {} ''
    mkdir -p $out/pack/mypack
    ln -sf /var/run/current-system/sw/share/vim-plugins $out/pack/mypack/opt
  '';
in pkgs.vim_configurable.customize {
  name = "vim";

  vimrcConfig.customRC = ''
    set packpath+=${symlinkPlugins}
  '' + (builtins.readFile ./vimrc);
}
