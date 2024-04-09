# dotfiles

- Enjoy the benefits of bash-it
- Install arch packages; `sudo pacman -S --needed - < packages.txt`
- Manage vim packages via builtin package manager(vim > 8)

## Arch packages
- Used `paru -Qqe > arch_packages.txt` to listup all packages.
    - `-Q` queries the package database
    - `-q` suppresses package version information, package names only
    - `-e` restricts the output to explicitly installed packages
- Use `pacman -S --needed - < arch_packages.txt` to install them all

