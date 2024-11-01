# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

###################################################
# Custom .bashrc    (below, above standard ubuntu)
###################################################

# supress, "The default interactive shell is..."
export BASH_SILENCE_DEPRECATION_WARNING=1

# changed to allow commands starting with space (from copy-paste) to be saved to history
export HISTCONTROL=ignoredups

################ PROMPT
__parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

__prompt_command() {
    local EXIT="$?"
    if [ $EXIT != 0 ]; then
        PS1=${PS1_ERR}
    else
        PS1=${PS1_OK}
    fi
}

bash_prompt(){
    local NONE='\[\033[0m\]'   # unsets color to term's fg color

    # misc junk
    local UNDERSCORE='ESC[04m'  # only works in xterms
    local BLINK='ESC[05m'       # doesn't work in xterms
    local REVERSE='ESC[07m'

    # regular colors
    local K='\[\033[0;30m\]'   # black
    local R='\[\033[0;31m\]'    # red
    local G='\[\033[0;32m\]'    # green
    local Y='\[\033[0;33m\]'    # yellow
    local B='\[\033[0;34m\]'    # blue
    local M='\[\033[0;35m\]'    # magenta
    local C='\[\033[0;36m\]'    # cyan
    local W='\[\033[0;37m\]'    # white

    # empahsized (bolded) colors
    local EMK='\[\033[1;30m\]'
    local EMR='\[\033[1;31m\]'
    local EMG='\[\033[1;32m\]'
    local EMY='\[\033[1;33m\]'
    local EMB='\[\033[1;34m\]'
    local EMM='\[\033[1;35m\]'
    local EMC='\[\033[1;36m\]'
    local EMW='\[\033[1;37m\]'

    # background colors
    local BGK='\[\033[40m\]'
    local BGR='\[\033[41m\]'
    local BGG='\[\033[42m\]'
    local BGY='\[\033[43m\]'
    local BGB='\[\033[44m\]'
    local BGM='\[\033[45m\]'
    local BGC='\[\033[46m\]'
    local BGW='\[\033[47m\]'
    local REV='\[\033[07m\]'
    local UC=$C                 # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color

    #PS1="${EMK}[${UC}\u${EMK}@${UC}\h ${EMB}\${NEW_PWD}${EMK}]${UC}\\$ ${NONE}"
    #PS1="${REV}[$(date "+%h%e -%l:%M%p") \w]${NONE}\n"
    #http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
    #PS1="${REV}[\D{%h%e} - \@ \w]${NONE}\n"
 
    PS1_TOP="${REV}[${USER}@\h \w]${NONE}${G}\$(__parse_git_branch)${NONE}\n"
    PS1_OK="${PS1_TOP} ${EMG}(\#)#>${NONE} "
    PS1_ERR="${PS1_TOP} ${EMR}(\#)#>${NONE} "
    PROMPT_COMMAND=__prompt_command
    export PS3='\h>'

    # fix resize issues in bash
    # https://unix.stackexchange.com/questions/61584/how-to-solve-the-issue-that-a-terminal-screen-is-messed-up-usually-after-a-res
    # export PROMPT_COMMAND="resize &>/dev/null ; $PROMPT_COMMAND"
    #export PROMPT_COMMAND="$PROMPT_COMMAND; resize &>/dev/null"

    # without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
}

bash_prompt
