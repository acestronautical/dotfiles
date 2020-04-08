#!/bin/bash

#######################################################
# PATH
#######################################################

# This is where you put your hand rolled scripts (remember to chmod them)
PATH="$HOME/bin:$PATH"

#######################################################
# GENERAL
#######################################################

iatest=$(expr index "$-" i)

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

#######################################################
# ALIASES
#######################################################

# Repeat the last command with sudo prefixed
alias please='sudo $(fc -ln -1)'

# Open with default application
alias open='xdg-open'

# Apt is always sudo
alias apt='sudo apt'

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

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d'`
 `' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

 # Star Wars
 alias starwars='telnet towel.blinkenlights.nl'

#######################################################
# APPLICATION DEPENDENT ALIASES & BINDINGS
#######################################################

# alias vi with vim if installed
if type vim &> /dev/null; then
	alias vi='vim'
fi

# alias cat with bat if installed
if type bat &> /dev/null; then
	alias cat='bat'
fi

# alias extract with unp if installed
if type unp &> /dev/null; then
	alias extract='unp'
fi

# alias xclip to systemwide clipboard if installed
if type xclip &> /dev/null; then
	# copy to clipboard. ex: cat file1 | toclip
	alias toclip='xclip -selection clipboard' 
	# paste from clipboard. ex: fromclip > file1, echo | fromclip
	alias fromclip='xclip -o -selection clipboard'
fi

# cow says things if cowsay and fortune installed
if type fortune &> /dev/null; then
	if type cowsay &> /dev/null; then
		fortune | cowsay
	fi
fi

# fzf keybindings if installed
if type fzf &> /dev/null; then
. /usr/share/doc/fzf/examples/key-bindings.bash
fi

# wordnet aliases (terminal dictionary)
if type wc &> /dev/null; then
	# lookup a words definitions
	definition() { 
		wn $1 -over 
	}
	# lookup a words synonyms
	synonym() { 
		wn $1 -synsn -synsv -synsa -synsr 
	}
	# lookup a words antonyms
	antonym() { 
		wn $1 -antsn -antsv -antsa -antsr 
	}
fi


#######################################################
# FUNCTIONS
#######################################################

# Automatically do an ls after each cd
cd () {
 	if [ -n "$1" ]; then
 		builtin cd "$@" && ls
 	else
 		builtin cd ~ && ls
 	fi
}

# Make a directory and immediately cd into it
mkcd() {
        if [ $# != 1 ]; then
                echo "Usage: mkcd <dir>"
        else
                mkdir -p $1 && cd $1
        fi
}

# Install recommended commands for this .bashrc file
install_bashrc_commands () {
		# fzf is a general-purpose command-line fuzzy finder.
		sudo apt-get install -y fzf
		# tldr shows usage examples of a command, similar to man
		sudo apt-get install -y tldr
		# xclip allows easy commandline access to the clipboard
		sudo apt-get install -y xclip
		# ripgrep recursively searches your current directory for with a regex.
		sudo apt-get install -y ripgrep
		# bat is a cat clone with added syntax highlighting
		sudo apt-get install -y bat
		# wordnet is a commandline thesaurus and dictionary
		sudo apt-get install -y wordnet
		# tree is a directory listing producing depth indented list of files. 
		sudo apt-get install -y tree  
		# multitail monitors logfiles and command output in multiple windows.
		sudo apt-get install -y multitail 
		# vim is an advanced terminal editor
		sudo apt-get install -y vim
		# baobab is a disk usage visualizer
		sudo apt-get install -y baobab
		# unp is a utility for unpacking archives of all kinds
		sudo apt-get install unp
		# show fortunes
		sudo apt-get install -y fortune-mod
		# make the cow say things
		sudo apt-get install -y cowsay
		# xcape allows for mapping a key tap vs a key hold
		sudo apt-get install -y xcape
	# re-source bashrc
	. ~/.bashrc
}