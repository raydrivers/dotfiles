# dotfiles

My dotfiles.
Currently for  Linux, MacOS, Windows (Git Bash).

### Setup

I assume `bash` and `git` are installed on every system.

```bash
git clone --recursive https://github.com/raydrivers/dotfiles ~/dotfiles
cd ~/dotfiles

./packages.sh
./setup.sh
```

It's important to install packages before running `setup.sh`,
it depends on some.

You can install linux desktop with `./setup.sh --desktop`

Setup logs:
- `+ name` - added or changed `name`
- `@ name` - ensured `name` was already present

Scripts are designed to be easy-to-maintain.
Just read them.
If it's hard to read - time for edit.

### Local shell config

Put your machine shell configuration under `.posix-profile`.

Don't edit `.zshrc` or `.bashrc`.

### Windows notes

- Symlinks on Windows Git Bash require Developer Mode
  enabled (Settings > Developer settings). Do that before clonning repo.
