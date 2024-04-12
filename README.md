# dotfiles

## Shell(Bash)
- *submodule*, fork of [bash-it](https://github.com/Bash-it/bash-it)

---

## Editor(Vim, main)
- highly recommend version 9+, rc written in vim9script
    - on purpose of escape-free feature especially configuring on LSP
    - 9+ provide core features including virtual text
- use builtin package manager, w/o plugin managers like vim-plug
- use [yegapann/lsp](https://github.com/yegappan/lsp) as a client of LSP
    - light weight
    - one-liner server registration
- packages:
    - jasonccox/vim-wayland-clipboard
    - tpope/vim-fugitive.git
    - airblade/vim-gitgutter
    - majutsushi/tagbar.git
    - rhysd/vim-healthcheck
    - tpope/vim-commentary
    - yegappan/lsp

---

### Caveats
- runtime-file(ftplugin/vim.vim) concludes rcfile's filetype, whether it is
 vim or vim9. The commenting plugin tpope/vim-commentary decides the comment-
 character to be " or # respectively. So vim9script phrase should be placed
 on the top of the rcfile.

## Editor(Neovim, sub)
- *submodule*, fork of [kickstart](https://github.com/nvim-lua/kickstart.nvim)
- For now, passive use as a plugin manager of LSP servers
    - not a fan of feature-fluent editor

---

## Distro(Arch)
- Used `paru -Qqe > arch_packages.txt` to listup all packages.
    - `-Q` queries the package database
    - `-q` suppresses package version information, package names only
    - `-e` restricts the output to explicitly installed packages
- Use `pacman -S --needed - < arch_packages.txt` to install them all

### Window manager(Hyprland)

#### Status bar(Waybar)

#### Browser (Qutebrowser)

---

## Todo
- [x] bootstrap @LSP/inlay-hint features
- [ ] setup @LSP/initializationOptions for jdtls to meet perfectly
- [ ] consider to use plugin/CtrlP
