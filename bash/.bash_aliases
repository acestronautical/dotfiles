#!/bin/bash

#######################################################
# PATH
#######################################################

# This is so python/pip commands are available
PATH="$PATH:$HOME/.local/bin"

# This is where you put your hand rolled scripts (remember to chmod them)
PATH="$PATH:$HOME/bin"

#######################################################
# GENERAL
#######################################################

iatest=$(expr index "$-" i)

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-unmodified On"; fi

#######################################################
# ALIASES
#######################################################

# Repeat the last command with sudo prefixed
alias please='sudo $(fc -ln -1)'

# Open with default application
alias open='xdg-open'

# Support cls
alias cls='clear'

# More informative commands
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'

# always make full path
alias mkdir='mkdir -p -v'

# cd typo alias
alias cd..='cd ..'

#######################################################
# APPLICATION DEPENDENT ALIASES & BINDINGS
#######################################################

# alias vi with vim if installed
if type vim &>/dev/null; then
	alias vi='vim'
fi

# alias extract with unp if installed
if type unp &>/dev/null; then
	alias extract='unp'
fi

# alias xclip to systemwide clipboard if installed
if type xclip &>/dev/null; then
	# copy to clipboard. ex: cat file1 | toclip
	alias toclip='xclip -selection clipboard'
	# paste from clipboard. ex: fromclip > file1 OR fromclip | cat
	alias fromclip='xclip -o -selection clipboard'
fi

# the cow says things if cowsay and fortune are installed
if type fortune &>/dev/null; then
	if type cowsay &>/dev/null; then
		fortune | cowsay
	fi
fi

# fzf keybindings if installed
if type fzf &>/dev/null; then
	# CTRL-T - Paste the selected files and directories onto the command-line
	# CTRL-R - Paste the selected command from history onto the command-line
	# ALT-C - cd into the selected directory
	. /usr/share/doc/fzf/examples/key-bindings.bash
fi

#######################################################
# FUNCTIONS
#######################################################

# Make an ssh key if not exists, and copy ssh key to clipboard
# needs xclip to copy to system clipboard
ssh-key-now() {
	cat /dev/zero | ssh-keygen -t ed25519 -C "made with ssh-key-now" -q -N ""
	xclip -sel clip <~/.ssh/id_ed25519.pub
	echo "ssh-key copied to clipboard"
}

# Automatically do an ls after each cd
cd() {
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

# Install recommended commands for this .bashrc file
install_bashrc_commands() {
	# baobab is a disk usage visualizer
	sudo apt-get install -y baobab
	# caffiene is a tray icon to keep pc from sleeping
	sudo apt-get install -y caffeine
	# copyq is a clipboard manager
	sudo apt-get install -y copyq
	# cowsay shows a cow saying things
	sudo apt-get install -y cowsay
	# fortune-mod shows fortunes/funny sayings
	sudo apt-get install -y fortune-mod
	# fzf is a general-purpose command-line fuzzy finder.
	sudo apt-get install -y fzf
	# ripgrep recursively searches your current directory for with a regex.
	sudo apt-get install -y ripgrep
	# tldr shows usage examples of a command, similar to man
	sudo apt-get install -y tldr
	# tree is a directory listing producing depth indented list of files.
	sudo apt-get install -y tree
	# unp is a utility for unpacking archives of all kinds
	sudo apt-get install -y unp
	# vim is an advanced terminal editor
	sudo apt-get install -y vim
	# xclip allows easy commandline access to the clipboard
	sudo apt-get install -y xclip

	# re-source bashrc
	. ~/.bashrc
}
