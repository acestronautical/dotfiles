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

Make sure you have installed GNU stow ```sudo apt install stow```

this repo must be cloned to ~ for stow to function as shown, if you wish to clone elsewhere use ```stow --target=~ <configuration>```

If a file already exists (such as .bashrc) then stow will fail with a conflict warning, this is the desired behavior so that existing configuration is not lost. If you wish to overwrite an existing configuration you must manually delete the existing file(s) and rerun stow.

## bash

Some parts of the .bashrc configuration (such as cowsay/fortune) require running ```install_bashrc_commands``` in order to function, to view/edit which commands will be installed scroll to the end of .bash_aliases.

## git

Make sure to change name and email to your own name and email!!!

## vscode

vscode files are located in ```~/.config/Code/User```. You will need to delete your existing vscode files before stow will work. Alternatively you may manually copy and paste the lines you would like.

## xmodmap

xmodmap will overload capslock to function as escape when pressed, and when held will provide arrow keys on the right hand home row. To change from inverted-T to vim style arrows edit the .xmodmap file. 

Note: you will need to ```chmod +x .xmodmap.sh``` then install the dependency xcape ```sudo apt install xcape```
