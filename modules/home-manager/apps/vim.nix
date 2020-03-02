{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    programs.neovim = {
      enable = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-airline
        vim-airline-themes

        vim-gitgutter
        syntastic
        youcompleteme
        nerdcommenter
        auto-pairs
        vim-closetag
        tagbar
        ctrlp
        editorconfig-vim
        tabular
      ];

      extraConfig = ''
        set shell=/bin/sh
        set nocompatible
        set cpoptions+=J

        " session, history, backups {{{
        " history
        set history=1000 " no. of commad line commands history
        set undofile " save undo history
        set undoreload=10000

        " only save buffers to session
        set sessionoptions=buffers

        call system("mkdir -p ~/.vim/tmp/{backup,undo,swap}")
        set backupdir=~/.vim/tmp/backup//                              " backups
        set backupskip=/tmp/*,/private/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*¬
        set undodir=~/.vim/tmp/undo//                                  " undo files
        set directory=~/.vim/tmp/swap//                                " swap files
        set backup                                                     " enable backups
        set noswapfile                                                 " It's 2012, Vim.
        " }}}

        " {{{ text and editing

        set encoding=utf-8

        set autoindent

        " characters to show for tab, eol, if wrap is off on the end
        set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮

        " insert spaces instead of tab char
        set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

        " do not read extra vim options from file headers
        set modelines=0

        " make backspace work over autoindents, line breaks and over start of inser
        set backspace=indent,eol,start

        " autowrite file on bufferswitch
        set autowrite

        " use multiple of shiftwidth when indenting with '<' and '>'
        set shiftround

        " better completion
        set completeopt=longest,menuone,preview

        " per project config
        set exrc
        " }}}

        " {{{ visual

        set showmode   " show mode (insert, replace, visual) in vim statusline
        set showcmd    " show executed command in statusline
        set hidden     " opening a new file will not close current file, but only hide it
        set cursorline " show where is cursor in statusline
        set ruler      " show ruler

        " terminal options
        set termguicolors " 24bit terminal colors
        set ttyfast       " because we use fast ttys today
        highlight Normal ctermbg=NONE guibg=NONE " transaparent terminal
        highlight NonText ctermbg=NONE guibg=NONE

        " themes
        " highlight Pmenu ctermfg=2 ctermbg=3 guifg=#ffffff guibg=#0000ff

        " syntax higlightning
        syntax on

        " no redraw executing macros, registers and other commands
        set lazyredraw

        " always show statusline (even when no windows are shown)
        set laststatus=2

        " line numbers
        set number " show line numbers
        set norelativenumber " do not show relative numbers

        " when a bracket is inserted, briefly jump to the matching one
        set showmatch
        set matchtime=3

        " character to show on line wraps
        set showbreak=↪

        " show split windows below and on right
        set nosplitbelow
        set splitright

        " better split window chars
        set fillchars=vert:┃,diff:⣿,fold:-

        " enable setting window title
        set title

        " wrapping and line breaking
        set wrap
        set colorcolumn=80

        " set all windows split rqual
        set equalalways

        " resize splits when the window is resized
        au VimResized * exe "normal! \<c-w>="

        " enable mouse
        set mouse=a
        if !has('nvim')
          set ttymouse=xterm2
        endif

        " Make sure Vim returns to the same line when you reopen a file.
        au BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute 'normal! g`"zvzz' |
            \ endif

        " hide preview window, set previewwindow options
        au CompleteDone * pclose
        autocmd WinEnter * if &previewwindow | setlocal nonumber | endif
        autocmd WinEnter * if &previewwindow | highlight ColorColumn | endif

        " enable wildmenu and set list to longest
        set wildmenu
        set wildmode=list:longest
        " }}} END: visual

        " {{{ filetypes

        filetype plugin on
        filetype indent plugin on

        " html
        au BufNewFile,BufRead *.html setlocal filetype=html

        " go
        au BufNewFile,BufRead *.go setlocal filetype=go
        au BufNewFile,BufRead *.nix setlocal filetype=nix

        " javascript
        au BufNewFile,BufRead *.js setlocal filetype=javascript
        au BufNewFile,BufRead *.mjs setlocal filetype=javascript
        au BufNewFile,BufRead *.ts setlocal filetype=typescript
        " }}} END: filetypes

        " {{{ keybinding
        " Set leader keys
        let mapleader=","
        let maplocalleader = ","

        " copy/paste
        set pastetoggle=<F2>
        noremap <Leader>y "*y " copy to terminal clipboard
        noremap <Leader>p "*p " paste from terminal clipboard
        noremap <Leader>Y "+y " copy to system clipboard
        noremap <Leader>P "+p " paste from system clipboard

        " leave in visual mode when indenting
        vnoremap > >gv
        vnoremap < <gv

        " show linebreaks
        nmap <C-l> :set list!<CR>

        " highlight search
        nmap <C-h> :set hlsearch!<CR>¬

        " toggle numbers
        nmap <C-n> :set number!<CR>

        " Change case
        nnoremap <C-u> g~iw

        " select all
        nmap <C-a> ggVG

        " Align text
        nnoremap <leader>Al :left<cr>
        nnoremap <leader>Ac :center<cr>
        nnoremap <leader>Ar :right<cr>

        " toggle tagbar
        nmap <LEADER>tb :TagbarToggle<CR>

        " buffers
        nnoremap <F5> :buffers<CR>:buffer<Space>

        " html
        au Filetype html inoremap <C-space> <CR><up><end><CR>

        " javascript
        au Filetype javascript imap <C-d> <esc>:JsDoc<CR><insert>

        " restructured text
        au FileType rst
            \ nnoremap <buffer> <localleader>1 yypVr= |
            \ nnoremap <buffer> <localleader>2 yypVr- |
            \ nnoremap <buffer> <localleader>3 yypVr~ |
            \ nnoremap <buffer> <localleader>4 yypVr`

        " }}} END: keybindings

        " {{{ plugins

        " == language plugins ==
        autocmd Filetype html
                    \ packadd vim-closetag
        autocmd Filetype go
                    \ packadd vim-go
        autocmd Filetype javascript
                    \ packadd vim-jsdoc |
                    \ packadd vim-flow

        " {{{ plugin options
        " theme
        let g:solarized_termtrans=1

        " airline
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
        let g:airline_right_alt_sep = ''
        let g:airline_right_sep = ''
        let g:airline_left_alt_sep= ''
        let g:airline_left_sep = ''

        " youcompleteme
        let g:ycm_autoclose_preview_window_after_insertion = 1
        let g:ycm_autoclose_preview_window_after_completion = 1

        " nerdcommenter
        let g:NERDCustomDelimiters = {'nix': { 'left': '#' }}

        " syntastic
        let g:syntastic_check_on_open=1
        let g:syntastic_auto_jump=0
        let g:syntastic_aggregate_errors = 1
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_loc_list_height=5
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_stl_format = '[%E{%e Errors}%B{, }%W{%w Warnings}]'
        let g:syntastic_javascript_eslint_args = '--compact'
        let g:syntastic_javascript_checkers=['eslint']
        let g:syntastic_rst_checkers=['sphinx']
        let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']

        " go
        let g:go_highlight_types = 1
        let g:go_highlight_fields = 1
        let g:go_highlight_functions = 1
        let g:go_highlight_methods = 1
        let g:go_highlight_extra_types = 1
        let g:go_highlight_generate_tags = 1
        let g:go_list_type = "quickfix"

        " flow
        let g:flow#enable = 0 " already done by syntastic
        let g:flow#omnifunc = 1

        " jsdoc
        let g:jsdoc_enable_es6 = 1
        let g:jsdoc_underscore_private = 1
        let g:jsdoc_input_description = 1
        let g:jsdoc_allow_input_prompt = 1

        " go
        let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
        let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }
        let g:go_list_type = "quickfix"

        " }}}

        " }}} END: plugins

        " disable unsafe commands from now on
        set secure
      '';
    };
  };
}
