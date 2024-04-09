" Author: moovinzoo@gmail.com
" Last Modified: (Apr 09 2024 - 01:37)
" Maintainer: The Vim Project <https://github.com/vim/vim>
" Reference: Vimrc checklist <https://www.reddit.com/r/vim/wiki/vimrctips/>
" Shell: bash
" Terminal: kitty
" Session: wayland
" LSP Client: @yegappan/lsp
" LSP Server Installer: Neovim/Mason

vim9script
filetype plugin indent on
set encoding=utf8

# ----------------------------------------------------------------------------
# Appearance
# ----------------------------------------------------------------------------
syntax enable
set termguicolors
set title
set ruler
set cursorline
set textwidth=78
set colorcolumn=+1              # enable colorcolumn as a border of textwidth
set laststatus=2                # always show statusline even w/ 1 buffer
set signcolumn=yes              # always show signcolumn even w/o git changes


# ----------------------------------------------------------------------------
# Text editing
# ----------------------------------------------------------------------------
# tab-size
set tabstop=16                  # visual length of \t nomatter from tab or not
set shiftwidth=8                # for indenting lines(>>) w/ cindent
set softtabstop=8               # for pressing <Tab>
set expandtab                   # 󱞩 cont'd, not going to use tab

# improve-search
set ignorecase                  # search behavior
set smartcase                   # 󱞩 cont'd
set hlsearch                    # 󱞩 cont'd
set incsearch                   # 󱞩 cont'd

set cindent                     # C-style indent
set list
set listchars=tab:>-,trail:-    # mark tabs and trailing spaces
set modeline
set modelines=5                 # support modelines
set scrolloff=5                 # keep lines below/above cursor when scrolling
set backspace=eol,start,indent  # backspace behavior
set whichwrap+=<,>,h,l
set magic                       # regular expressions


# ----------------------------------------------------------------------------
# Accessibility
# ----------------------------------------------------------------------------
set noequalalways               # do not equalize the size of the buffers
set wildmenu                    # support wildcard-matching
set showcmd                     # display incomplete commands
set lazyredraw                  # not to redraw during execution of macros
set noerrorbells                # no sound/blink on errors
set novisualbell                # 󱞩 cont'd
set showmatch                   # visual: show matching brackets
set mat=5                       # 󱞩 cont'd
set history=300                 # keep command line history
set clipboard=unnamedplus       # share system clipboard
set keywordprg=:LspHover        # give priority to LspHover for K
runtime! ftplugin/man.vim       # display man pages in a Vim buffer


# ----------------------------------------------------------------------------
# Files, backups, undos
# ----------------------------------------------------------------------------
set nobackup                    # do not create backup files
set autoread                    # read-only if the file is modified outside
set ffs=unix,dos,mac            # filetype preference order
if has('persistent_undo')       # keep undo changes after closing
        set undofile
endif


## ----------------------------------------------------------------------------
## Mapping
## ----------------------------------------------------------------------------
g:mapleader = " "

nnoremap H ^
nnoremap L g_
nnoremap vv viw
nnoremap Q :q<CR>
nnoremap <Esc> :noh<CR>
# quick window-switching
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
# prevent frequent mis-use
nnoremap <S-j> <Nop>
nnoremap <silent> <leader>p :TagbarToggle<CR>
nnoremap <silent> <leader>hc <ScriptCmd>HandyCommit()<CR>

# prevent diagnostic interruption
inoremap <C-c> <C-[>
# restore shell-style keymaps
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-y> <C-r>

vnoremap H ^
vnoremap L g_

# restore shell-style keymaps
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-y> <C-r>0

tnoremap <Esc> <C-\><C-n>


" Modify highlights for diff to be minimal
function! ReplaceDiffHighlightsWithBlueAndRedOnly() abort
        highlight DiffAdd    guifg=NONE guibg=MidnightBlue
        highlight DiffDelete guifg=NONE guibg=MidnightBlue
        highlight DiffChange guifg=NONE guibg=MidnightBlue
        highlight DiffText   guifg=NONE guibg=DarkRed
endfunction

" Modify highlights for cursorline not to interupt diff-highlighted lines
function! ReplaceCursorLineHighlight() abort
        highlight CursorLine cterm=underline ctermbg=NONE guibg=NONE
endfunction

" Dim down sign-column
function! DimDownSignColumnHighlight() abort
        highlight SignColumn guibg=#111111
endfunction

" Hard-copy kitty-term's current theme(adwaita)
function! RestoreAnsiColorsThatCurrentTermUses() abort
        let g:terminal_ansi_colors = [
                                \ '#000000', '#ed333b', '#57e389', '#ff7800',
                                \ '#62a0ea', '#9141ac', '#5bc8af', '#deddda',
                                \ '#9a9996', '#f66151', '#8ff0a4', '#ffa348',
                                \ '#99c1f1', '#dc8add', '#93ddc2', '#f6f5f4',
                                \]
endfunction

function! HandyCommit() abort
        let message = input("Commit) ")
# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

        redraw!

        if strlen(message) > 0
                " Escape double quotes in the message
                let message = substitute(message, '"', '\\"', 'g')
                " Execute the git commit command
                let cmd = 'git commit -m "' . message . '"'
                let output = system(cmd)

                " Show feedback in the command line
                echo output
        else
                echoerr "Error: Commit message cannot be empty"
        endif
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

augroup EnableMinimalDiffHighlights
        autocmd!
        " only use 2-colors in diff-view
        autocmd ColorScheme * call ReplaceDiffHighlightsWithBlueAndRedOnly()
augroup END

augroup EnableUnderlineOnCursorLine
        autocmd!
        " only use underline for cursorline
        autocmd ColorScheme * call ReplaceCursorLineHighlight()
augroup END

augroup SyncTerminalColorsWithOutside
        autocmd!
        " restore 16 colors that is ruined by using termguicolors option
        autocmd ColorScheme * call RestoreAnsiColorsThatCurrentTermUses()
augroup END

augroup ReplaceSignColumnHighlightForPabloColorScheme
        autocmd!
        autocmd ColorScheme pablo call DimDownSignColumnHighlight()
augroup END

" use built-in colorscheme, weirdly placed here to be below augroup registered
colorscheme pablo
" set background=dark


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
let g:gitgutter_preview_win_floating = 1

" [plugin: Tagbar]
" limit width to 30
let g:tagbar_width=30
" hide help banner
let g:tagbar_compact=2
" to be sorted according to their order
let g:tagbar_sort=0
" configure autoopen
" autocmd VimEnter * nested :call tagbar#autoopen(1)

" [plugin: LSP](https://github.com/yegappan/lsp)
" Enable package
packadd lsp
" Replace keyword-prg(K) action from man to LspHover
set keywordprg=:LspHover
" Servers
" " Lua (https://github.com/luals/lua-language-server)
call LspAddServer([#{
                        \ name: 'lua-language-server',
                        \ filetype: ['lua'],
                        \ path: '/home/djlee/.vim/server/lua-language-server/lua-language-server',
                        \ args: []
                        \  }])
" " Java (https://github.com/eclipse-jdtls/eclipse.jdt.ls?tab=readme-ov-file)
call LspAddServer([#{
                        \ name: 'jdtls',
                        \ filetype: ['java'],
                        \ path: '/home/djlee/.vim/server/jdtls/jdtls',
                        \ args: []
                        \  }])
" Options
call LspOptionsSet(#{
                        \ showDiagWithVirtualText: v:true,
                        \ diagVirtualTextAlign: 'after',
                        \ })
