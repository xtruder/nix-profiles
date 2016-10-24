{ vim_configurable, vimPlugins }:

vim_configurable.customize {
  name = "vim-with-plugins";

  vimrcConfig.vam.knownPlugins = vimPlugins;

  vimrcConfig.vam.pluginDictionaries = [
    {names = [
      "airline" # status bar
      "molokai" # theme
      "supertab" # tabs
      "syntastic" # you know syntax hightlight
      "gitgutter" # git magic
      "tagbar" # for ctags
      "vim-signify" # like gitgutter but for other vcs
      "vim-indent-guides" # show lines for indents
      "nerdcommenter" # indents
      "tabular" # indenting
      "delimitmate" # closing of quotes, parenthesis, brackets, etc
      "youcompleteme" # autocompletion
      "UltiSnips" # ultimate snippets or smth
      "vim-snippets" # collection of snippets
      "command-t"
      "vim-multiple-cursors" # because search replace sucks
      "nerdtree" # the tree i don't need
      "sparkup" # you know div#header + div#footer magic
    ];}
    { name = "vim-spakup"; ft_regex = "html"; }
  ];
}
