" Author: moovinzoo@gmail.com
" Last Modified: (Mar 25 2024 - 22:37)
" Reference: The Vim Project <https://github.com/vim/vim>
" Guide: Vimrc checklist <https://www.reddit.com/r/vim/wiki/vimrctips/>
" Environment:
" " SHELL: bash
" " TERM: kitty
" " XDG_SESSION_TYPE: wayland
" " Netrw_gx_handler: qute


" ---------------------------------------------------------------------------
" [basic]
"
" filetype plugins
filetype plugin on

" load indent files, to automatically do language-dependent indenting
filetype indent on


" ---------------------------------------------------------------------------
" [appearance]
"
" syntax highlighting
syntax enable

" utf encoding
set encoding=utf8

" enable true colors
set termguicolors

" title
set title

" show current position
set ruler

" highlight current line
set cursorline

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
" tab size
" - for indenting lines; cindent, shiftwidth(>>)
" - for pressing <Tab>; expandtab, smarttab, softtabstop
" - for the visual length of a tab character(\t), whether it's from
" pressing the Tab key or not; tabstop
set tabstop=16
set softtabstop=8
set shiftwidth=8
set expandtab

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
inoremap <C-y> <C-r>0
" insert current datetime
" inoremap <C-'> <C-R>=InsertDateTime()<CR>

" [mapping: visual mode]
vnoremap H ^
vnoremap L g_

" [mapping: command mode]
" restore shell keymaps in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-y> <C-r>0


" ---------------------------------------------------------------------------
" [functions]
"
" Enable to insert datetime format
function! InsertDateTime() abort
        return strftime("(%b %d %Y - %H:%M)")
endfunction

" Modify highlights for diff to be minimal
function! ReplaceDiffHighlightsWithBlueAndRedOnly() abort
        highlight DiffAdd    guifg=NONE guibg=MidnightBlue
        highlight DiffDelete guifg=NONE guibg=MidnightBlue
        highlight DiffChange guifg=NONE guibg=MidnightBlue
        highlight DiffText   guifg=NONE guibg=DarkRed
endfunction



" ---------------------------------------------------------------------------
" [augroups]
" compiled with the +eval feature, revert with ':autocmd! sth' 
"
augroup AlwaysJumpToTheLastKnownCursorPosition
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

augroup SmoothScrollTillEndOfDocument
        autocmd!
        " built-in Smooth-scroll w/ <C-e>, <C-y> till the end line
        autocmd FileType *
                                \ set wrap |
                                \ set linebreak |
                                \ set display=lastline |
                                \ set smoothscroll
augroup END

" use built-in colorscheme, weirdly placed here to be below augroup registered
colorscheme lunaperche
set background=dark


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
" [plugins]
"
" [plugin: TermDebug(built-in)]
" enable builtin package
packadd! termdebug
"
" [plugin: Netrw(built-in)]
" tree style listing
let g:netrw_liststyle=3
" suppress banner
let g:netrw_banner=0
" specify initial size to 25%
let g:netrw_winsize=25

" [plugin: Fugitive]
" always show status line
set laststatus=2

" [plugin: GitGutter]
" diffmarkers should appear automatically after a short delay (default:4000)
set updatetime=100
" always show sign column without redraw (default: auto)
set signcolumn=yes

" [plugin: Tagbar]
" limit width to 30
let g:tagbar_width=30
" hide help banner
let g:tagbar_compact=2
" to be sorted according to their order
let g:tagbar_sort=0
" configure autoopen
" autocmd VimEnter * nested :call tagbar#autoopen(1)


"TODO: comment plugin
"TODO: Install vim-lsp
"TODO: Install vim-lsp-settings
"TODO: Install checkhealth
