#!/bin/bash
#######################################################
# ALIASES
#######################################################

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Repeat the last command with sudo prefixed
alias please='sudo $(fc -ln -1)'

# Open with default application
alias open='xdg-open'

# .bashrc commands
alias source_bashrc='. ~/.bashrc'
alias bashrc='edit ~/.bashrc'
alias bash_aliases='edit ~/.bash_aliases'

# Apt aliases
alias apt='sudo apt'

# support cls
alias cls='clear'

# more informative commands
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'

# always make full path
alias mkdir='mkdir -p'
# show all processes
alias ps='ps auxf'

# remove redundant log entries
alias multitail='multitail --no-repeat -c'

# vi is vim
alias vi='vim'

# Change directory aliases
alias cd..='cd ..'

# ls aliases
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias l='ls -CF'
alias la='ls -Alh' # show hidden files
alias lw='ls -xAh' # wide listing format
alias ll='ls -Fls' # long listing format
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

#######################################################
# FUNCTIONS
#######################################################

#Automatically do an ls after each cd
cd ()
{
 	if [ -n "$1" ]; then
 		builtin cd "$@" && ls
 	else
 		builtin cd ~ && ls
 	fi
}

# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Show the current distribution
distribution ()
{
	local dtype
	# Assume unknown
	dtype="unknown"
	
	# First test against Fedora / RHEL / CentOS / generic Redhat derivative
	if [ -r /etc/rc.d/init.d/functions ]; then
		source /etc/rc.d/init.d/functions
		[ zz`type -t passed 2>/dev/null` == "zzfunction" ] && dtype="redhat"
	
	# Then test against Debian, Ubuntu and friends
	elif [ -r /lib/lsb/init-functions ]; then
		source /lib/lsb/init-functions
		[ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && dtype="debian"

	fi
	echo $dtype
}

# Automatically install the needed support files for this .bashrc file
install_bashrc_commands ()
{
	local dtype
	dtype=$(distribution)

	if [ $dtype == "debian" ]; then
		# APT
		# MultiTail allows you to monitor logfiles and command output in multiple windows.
		sudo apt install multitail 
		# Tree is a recursive directory listing program that produces a depth indented listing of files. 
		sudo apt install tree 
		# fd is a simple, fast and user-friendly alternative to find
		sudo apt install fd-find 
		# fzf is a general-purpose command-line fuzzy finder.
		sudo apt install fzf 
		# fasd offers quick access to files and directories for POSIX shells
		sudo apt install fasd
		# ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern.
		sudo apt install ripgrep
		# show fortunes
		sudo apt install fortune-mod
		# make the cow say things
		sudo apt install cowsay
		
		# PIP
		sudo apt install python3-dev python3-pip python3-setuptools
		# The Fuck is a magnificent app that corrects errors in previous console commands.
		sudo pip3 install thefuck
		
		# NPM
		sudo apt install npm
		# undollar strips the dollar sign from the beginning of the terminal command you just copied from StackOverflow
		sudo npm install -g undollar
		# A collection of simplified and community-driven man pages.
		sudo npm install -g tldr
	elif [ $dtype == "redhat" ]; then
		echo "please add redhat support and make a pull request"
	else
		echo "unsupported distribution, you must install manually"
	fi
}