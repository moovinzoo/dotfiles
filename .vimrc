" Author: moovinzoo@gmail.com
" Last Modified: (Mar 25 2024 - 22:37)
" Reference: The Vim Project <https://github.com/vim/vim>
" Environment:
" " SHELL: bash
" " TERM: kitty
" " XDG_SESSION_TYPE: wayland
" " Netrw_gx_handler: qute


" ---------------------------------------------------------------------------
" [basic]
"
" use vim mode (not Vi-compatible)
set nocompatible

" filetype plugins
filetype plugin on

" load indent files, to automatically do language-dependent indenting
filetype indent on

" support kitty terminal
source $HOME/.vim/kitty_support.vim


" ---------------------------------------------------------------------------
" [appearance]
"
" syntax highlighting
syntax enable

" utf encoding
set encoding=utf8

" enable true colors
set termguicolors

" use built-in colorscheme
colorscheme industry

" overwrite too much color-use in diff with restoring syntax highlight
highlight DiffAdd    guifg=NONE guibg=MidnightBlue
highlight DiffDelete guifg=NONE guibg=MidnightBlue
highlight DiffChange guifg=NONE guibg=MidnightBlue
highlight DiffText   guifg=NONE guibg=DarkRed

" title
set title

" show current position
set ruler

" highlight current line
set cursorline

" show @@@ in the last line if it is truncated
set display=truncate

" do not equalize the size of the buffers
set noequalalways

" wildcard matching
set wildmenu

" display incomplete commands
set showcmd

" no redraw during execution of macros
set lazyredraw

" visual: show matching brackets
set showmatch
set mat=5

" no sound/blink on errors
set noerrorbells
set novisualbell


" ---------------------------------------------------------------------------
" [files, backups, and undo]
"
" do not create backup files
set nobackup

" keep undo changes after closing
if has('persistent_undo')
        set undofile
endif

" set to read-only if the file is modified from the outside
set autoread

" filetype order preference
set ffs=unix,dos,mac


" ---------------------------------------------------------------------------
" [text editing]
"
" tab indent: 8 and no tabs (replace by spaces)
set tabstop=8
set shiftwidth=8
set expandtab
set softtabstop=8

" C-style indent
set cindent

" mark tabs and trailing spaces
set list
set listchars=tab:>-,trail:-

" keep 3 lines below/above cursor when scrolling
set scrolloff=5

" support modelines (support exceptional tab size on file with :vim comment)
set modeline
set modelines=5

" keep 200 lines of command line history
set history=200

" backspace behavior
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" search behavior
set ignorecase
set smartcase
set hlsearch
set incsearch

" regular expressions
set magic


" ---------------------------------------------------------------------------
" [accessibility]
"
" share system clipboard, powered by vim-wayland-clipboard
set clipboard=unnamedplus

" display man pages in a Vim buffer
runtime! ftplugin/man.vim


" ---------------------------------------------------------------------------
" [mappings]
"
" leader key
let mapleader=" "

" [mapping: normal mode]
nnoremap vv viw
nnoremap H ^
nnoremap L g_
nnoremap Q :q<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>Q :qa<CR>
nnoremap <Leader>; :windo if &diff \| diffoff \| else \| diffthis \| endif<CR>

" [mapping: insert mode]
" restore shell keymaps in insert mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-y> <C-r>0
" insert current datetime
inoremap <C-'> <C-R>=InsertDateTime()<CR>

" [mapping: visual mode]
vnoremap H ^
vnoremap L $

" [mapping: command mode]
" restore shell keymaps in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-y> <C-r>0


" ---------------------------------------------------------------------------
" [augroups]
"
" compiled with the +eval feature, revert with ':autocmd! sth' 
if 1
        augroup vimStartup
                autocmd!

                " When editing a file, always jump to the last known cursor
                " position. Don't do it when the position is invalid, when
                " inside an event handler (happens when dropping a file on
                " gvim), for a commit or rebase message (likely a different
                " one than last time), and when using xxd(1) to filter
                " and edit binary files (it transforms input files back and
                " forth, causing them to have dual nature, so to speak)
                autocmd BufReadPost *
                        \ let line = line("'\"")
                        \ | if line >= 1 && line <= line("$")
                        \      && &filetype !~# 'commit'
                        \      && index(['xxd', 'gitrebase'], &filetype) == -1
                        \ |   execute "normal! g`\""
                        \ | endif

        augroup END

        augroup editFile
                autocmd!
                " built-in Smooth-scroll w/ <C-e>, <C-y> till the end line
                autocmd FileType *
                                        \ set wrap |
                                        \ set linebreak |
                                        \ set display=lastline |
                                        \ set smoothscroll
        augroup END
endif


" ---------------------------------------------------------------------------
" [commands]
"
" [command: DiffOrig]
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
" Close with: ":only", <C-W>o.
if !exists(":DiffOrig")
        command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
                                \ | diffthis | wincmd p | diffthis
endif

" [command: DiffMode]
" Convenient command to see the difference between the two buffers.
" Revert with: ":delcommand DiffMode".
" Close with: ":q".
if !exists(":DiffMode")
    command! DiffMode windo if &diff | diffoff | else | diffthis | endif
endif


" ---------------------------------------------------------------------------
" [functions]
"
" [function: InsertDateTime]
function! InsertDateTime()
        return strftime("(%b %d %Y - %H:%M)")
endfunction


" ---------------------------------------------------------------------------
" [plugin configs]
"
" " [plugin: TermDebug]
" https://github.com/vim/vim/blob/master/runtime/pack/dist/opt/termdebug
packadd! termdebug
