# dotfiles

## Shell(Bash)
- submodule, fork of [bash-it](https://github.com/Bash-it/bash-it)

---

## Editor(Vim, main)
- highly recommend version 9+, rc written in vim9script
    - on purpose of escape-free config on LSP
    - 9+ provide core features including virtual text
- use builtin package manager, w/o plugin managers like vim-plug
- use [yegapann/lsp](https://github.com/yegappan/lsp) as a client of LSP
    - light weight
    - one-liner server registration

## Editor(Neovim, sub)
- submodule, fork of [kickstart](https://github.com/nvim-lua/kickstart.nvim)
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
