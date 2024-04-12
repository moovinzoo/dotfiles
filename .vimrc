vim9script
# Author: moovinzoo@gmail.com
# Last Modified: (Apr 09 2024 - 01:37)
# Maintainer: The Vim Project <https://github.com/vim/vim>
# Reference: Vimrc checklist <https://www.reddit.com/r/vim/wiki/vimrctips/>
# Shell: bash
# Terminal: kitty
# Session: wayland
# LSP Client: @yegappan/lsp
# LSP Server Installer: Neovim/Mason
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
colorscheme envy


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
set keywordprg=:LspHover        # improve K behavior(priority)
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


# ----------------------------------------------------------------------------
# Mapping
# ----------------------------------------------------------------------------
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

vnoremap H ^
vnoremap L g_

# restore shell-style keymaps
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-y> <C-r>0

tnoremap <Esc> <C-\><C-n>
# quick window-switching
tnoremap <C-h> <C-w><C-h>
tnoremap <C-j> <C-w><C-j>
tnoremap <C-k> <C-w><C-k>
#tnoremap <C-l> <C-w><C-l>              # disable to keep <clear> in term


# ----------------------------------------------------------------------------
# Kitty support
# ----------------------------------------------------------------------------
if $TERM == 'xterm-kitty'
        # Mouse support
        set mouse=a
        set ttymouse=sgr
        set balloonevalterm
        # Styled and colored underline support
        &t_AU = "\e[58:5:%dm"
        &t_8u = "\e[58:2:%lu:%lu:%lum"
        &t_Us = "\e[4:2m"
        &t_Cs = "\e[4:3m"
        &t_ds = "\e[4:4m"
        &t_Ds = "\e[4:5m"
        &t_Ce = "\e[4:0m"
        # Strikethrough
        &t_Ts = "\e[9m"
        &t_Te = "\e[29m"
        # Truecolor support
        &t_8f = "\e[38:2:%lu:%lu:%lum"
        &t_8b = "\e[48:2:%lu:%lu:%lum"
        &t_RF = "\e]10;?\e\\"
        &t_RB = "\e]11;?\e\\"
        # Bracketed paste
        &t_BE = "\e[?2004h"
        &t_BD = "\e[?2004l"
        &t_PS = "\e[200~"
        &t_PE = "\e[201~"
        # Cursor control
        &t_RC = "\e[?12$p"
        &t_SH = "\e[%d q"
        &t_RS = "\eP$q q\e\\"
        &t_SI = "\e[5 q"
        &t_SR = "\e[3 q"
        &t_EI = "\e[1 q"
        &t_VS = "\e[?12l"
        # Focus tracking
        &t_fe = "\e[?1004h"
        &t_fd = "\e[?1004l"
        execute "set <FocusGained>=\<Esc>[I"
        execute "set <FocusLost>=\<Esc>[O"
        # Window title
        &t_ST = "\e[22;2t"
        &t_RT = "\e[23;2t"

        # vim hardcodes background color erase even if the terminfo file does
        # not contain bce. This causes incorrect background rendering when
        # using a color theme with a background color in terminals such as
        # kitty that do not support background color erase.
        &t_ut = ''
endif


# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
def JumpToTheLastKnownCursorLocation()
        var line = line("'\"")
        if line >= 1 && line <= line("$")
                        && &filetype !~# 'commit'
                        && index(['xxd', 'gitrebase'], &filetype) == -1
                execute "normal! g`\""
        endif
enddef

# User-defines
def HandyCommit()
        cd %:h | w      # cd to buffer's dir and write changes before commit
        var message = input("Commit) ")
        redraw!
        if strlen(message) > 0
                message = substitute(message, '"', '\\"', 'g')
                var cmd = 'git commit -m "' .. message .. '"'
                var output = system(cmd)
                echo output
        else
                echoerr "Error: Commit message cannot be empty"
        endif
enddef

def DefineDiffOrigCommand()
        execute 'command! DiffOrig vert new | set bt=nofile | r ++edit '
                .. expand("%p") .. ' |: 0d | diffthis | wincmd p | diffthis'
enddef


# ----------------------------------------------------------------------------
# Autocmds
# ----------------------------------------------------------------------------
augroup SmoothScrollTillEndOfDocument
        autocmd!
        autocmd FileType * {
                set wrap |
                set linebreak |
                set display=lastline |
                set smoothscroll
        }
augroup END

augroup RestoreLastCursorLocation
        autocmd!
        autocmd BufReadPost * {
                JumpToTheLastKnownCursorLocation()
        }
augroup END

augroup RegisterUserDefineCommands
        autocmd!
        autocmd BufReadPost * {
                DefineDiffOrigCommand()
        }
augroup END

augroup AlwaysCdToBufferDir
        autocmd!
        autocmd BufReadPost * cd %:p:h
augroup END


# ----------------------------------------------------------------------------
# Plugins
# ----------------------------------------------------------------------------
# [TermDebug(built-in]
packadd! termdebug

# Netrw(built-in)]
g:netrw_liststyle = 3                           # tree-style listing
g:netrw_banner = 0                              # suppress help
g:netrw_winsize = 25                            # specify initial size to 25%

# Fugitive

# GitGutter
set updatetime=100                              # diffmarkers (default: 4000)
# TODO: how to focus on popup window?
g:gitgutter_preview_win_floating = 1

# Tagbar
g:tagbar_width = 30                             # limit width to 30
g:tagbar_compact = 2                            # suppress help
g:tagbar_sort = 0

# LSP (https://github.com/yegappan/lsp)
packadd lsp
setlocal formatexpr=lsp#lsp#FormatExpr()        # improve gq behavior
var baseDir = '/home/djlee/.vim/server/'
g:LspAddServer([
        {
                name: 'lua-language-server',
                filetype: 'lua',
                path: baseDir .. 'lua-language-server/lua-language-server',
                args: [],
        },
        {
                name: 'jdtls',
                filetype: 'java',
                path: baseDir .. '/jdtls/jdtls',
                args: [],
                initializationOptions: {
                        settings: {
                                java: {
                                        inlayHints: {
                                                parameterNames: {
                                                        enabled: 'all',
                                                },
                                        },
                                },
                        },
                        features: {
                                inlayHints: true,
                        },
                },
        },
])

g:LspOptionsSet({
        showDiagWithVirtualText: true,
        diagVirtualTextAlign: 'after',
        showInlayHints: true,
})

