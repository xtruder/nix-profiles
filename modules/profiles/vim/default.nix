{ config, pkgs, lib, ... }: 

with lib;

let
  symlinkPlugins = pkgs.runCommand "symlinkPlugin" {} ''
    mkdir -p $out/pack/mypack
    ln -sf /var/run/current-system/sw/share/vim-plugins $out/pack/mypack/opt
  '';

in {
  programs.vim.vimrc = mkDefault (''
    set packpath+=${symlinkPlugins}
  '' + (builtins.readFile ./vimrc));

  environment.systemPackages = with pkgs; with vimPlugins; [
    vim-airline
    vim-airline-themes
    Solarized

    vim-gitgutter
    syntastic
    YouCompleteMe
    nerdcommenter
    auto-pairs
    vim-closetag
    tagbar
    ctrlp
    editorconfig-vim
    tabular
  ];
}
