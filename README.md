# My Dotfiles

Managed with [stow](https://www.gnu.org/software/stow/)

## Install

```
cd ~
git clone https://github.com/Ace-Cassidy/dotfiles.git
stow <configuration>
```

To install a configuration simply execute ```stow <folder>``` from within this directory. 

For example ```stow bash``` will create a symlinks in ~ for .bashrc and .bash_aliases

## Why isn't it working?

this repo must be cloned to ~ for stow to function as shown, if you wish to clone elsewhere use ```stow --target=~ <configuration>```

If a dotfile already exists (such as .bashrc) then stow will fail with a conflict warning, this is the desired behavior so that existing configuration is not lost. If you wish to overwrite an existing configuration you must manually delete the existing file(s) and rerun stow.

Some parts of the .bashrc configuration (such as cowsay/fortune) require running ```install_bashrc_commands``` in order to function, to view/edit which commands are installed scroll to the end of .bash_aliases.