# dotfiles

Collection of dotfiles, mostly for syncing between computers.

Currently using running Manjaro with Awesome WM, installed via the Architect Edition.

## specific to my setup
- the "confgit" alias in .bashrc for using this repo points to a specific folder in my Documents

## dependencies
- [neovim](https://wiki.archlinux.org/index.php/Neovim) - just for XDG Base Directory compliance
- [lsd](https://www.archlinux.org/packages/community/x86_64/lsd/) - cause I like the unicode icons

## init files map
While trying to make sense of /etc/profile, .profile, .bashrc and xinitrc, I made a mess of a map for who calls what:

![dotfiles chart](https://github.com/misabiko/dotfiles/raw/master/dotfiles.png)
