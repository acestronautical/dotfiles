# My Dotfiles

Managed with [stow](https://www.gnu.org/software/stow/)

To install a configuration simply execute ```stow folder``` from within this directory. 

For example ```stow bash``` will create a symlink in ~ for .bashrc

If a dotfile already exists then stow will fail with a conflict warning, this is the desired behavior so that existing configuration is not lost. If you still wish to install the given configuration simply delete the existing config. 