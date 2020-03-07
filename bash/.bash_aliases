#!/bin/bash

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

# Detect the current linux distribution variant
distribution () {
	local dtype
	# Assume unknown
	dtype="unknown"
	
	# First test against Fedora / RHEL / CentOS / generic Redhat derivative
	if [ -r /etc/rc.d/init.d/functions ]; then
		source /etc/rc.d/init.d/functions
		[ zz`type -t passed 2>/dev/null` == "zzfunction" ]\
		&& dtype="redhat"
	
	# Then test against Debian, Ubuntu and friends
	elif [ -r /lib/lsb/init-functions ]; then
		source /lib/lsb/init-functions
		[ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ]\
		&& dtype="debian"

	fi
	echo $dtype
}

# Install recommended commands for this .bashrc file
install_bashrc_commands () {
	local dtype
	dtype=$(distribution)

	if [ $dtype == "debian" ]; then

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
		
	elif [ $dtype == "redhat" ]; then
		echo "please add redhat support and make a pull request"
	else
		echo "unsupported distribution, you must install manually"
	fi

	# resource bashrc
	. ~/.bashrc
}


#######################################################
# COLORS AND PROMPT
#######################################################

# Define colors
LIGHTGRAY="\033[0;37m"
WHITE="\033[1;37m"
BLACK="\033[0;30m"
DARKGRAY="\033[1;30m"
RED="\033[0;31m"
LIGHTRED="\033[1;31m"
GREEN="\033[0;32m"
LIGHTGREEN="\033[1;32m"
BROWN="\033[0;33m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
LIGHTBLUE="\033[1;34m"
MAGENTA="\033[0;35m"
LIGHTMAGENTA="\033[1;35m"
CYAN="\033[0;36m"
LIGHTCYAN="\033[1;36m"
OCHRE="\033[38;5;95m"
NOCOLOR="\033[0m"

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1

function git_branch() {
  # On branches this will return the branch name, else empty string
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ "$ref" != "" ]]; then
    echo "($ref)"
  fi
}

function __setprompt
{
	local LAST_COMMAND=$? # Must come first!

	# Show error exit code if there is one
	if [[ $LAST_COMMAND != 0 ]]; then
		PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]"`
		`"Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])-(\[${RED}\]"
		if [[ $LAST_COMMAND == 1 ]]; then
			PS1+="General error"
		elif [ $LAST_COMMAND == 2 ]; then
			PS1+="Missing keyword, command, or permission problem"
		elif [ $LAST_COMMAND == 126 ]; then
			PS1+="Permission problem or command is not an executable"
		elif [ $LAST_COMMAND == 127 ]; then
			PS1+="Command not found"
		elif [ $LAST_COMMAND == 128 ]; then
			PS1+="Invalid argument to exit"
		elif [ $LAST_COMMAND == 129 ]; then
			PS1+="Fatal error signal 1"
		elif [ $LAST_COMMAND == 130 ]; then
			PS1+="Script terminated by Control-C"
		elif [ $LAST_COMMAND == 131 ]; then
			PS1+="Fatal error signal 3"
		elif [ $LAST_COMMAND == 132 ]; then
			PS1+="Fatal error signal 4"
		elif [ $LAST_COMMAND == 133 ]; then
			PS1+="Fatal error signal 5"
		elif [ $LAST_COMMAND == 134 ]; then
			PS1+="Fatal error signal 6"
		elif [ $LAST_COMMAND == 135 ]; then
			PS1+="Fatal error signal 7"
		elif [ $LAST_COMMAND == 136 ]; then
			PS1+="Fatal error signal 8"
		elif [ $LAST_COMMAND == 137 ]; then
			PS1+="Fatal error signal 9"
		elif [ $LAST_COMMAND -gt 255 ]; then
			PS1+="Exit status out of range"
		else
			PS1+="Unknown error code"
		fi
		PS1+="\[${DARKGRAY}\])\[${NOCOLOR}\]\n"
	else
		PS1=""
	fi

	# Skip to the next line
	PS1+="\n"

	# Current directory
	PS1+="\[${LIGHTGRAY}\]\w "

	# Time
	PS1+="\[${LIGHTGRAY}\]\t " 

	# Skip to the next line
	PS1+="\n"

	# Git Branch
	PS1+="\[${GREEN}\]\$(git_branch)"

	if [[ $EUID -ne 0 ]]; then
		PS1+="\[${GREEN}\]$\[${NOCOLOR}\] " # Normal user
	else
		PS1+="\[${LIGHTRED}\]#\[${NOCOLOR}\] " # Root user
	fi

	# PS2 is used to continue a command using the \ character
	PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "

	# PS3 is used to enter a number choice in a script
	PS3='Please enter a number from above list: '

	# PS4 is used for tracing a script in debug mode
	PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}
PROMPT_COMMAND='__setprompt'
