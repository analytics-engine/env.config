# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#################################################################################

#                bash Prompt

#################################################################################

PS1=$'\1\r\1\e[7m\1{$(hostname -s)}\1\e[0m\1 '":\$PWD 
> "


#################################################################################

#                bash History

#################################################################################

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#################################################################################

#               Logging

#################################################################################

if [ -z $LOGDIR ]; then
   LOGDIR="$HOME/.logs"
   LOG="$LOGDIR/session.log"
fi

#################################################################################

#                bash Terminal and Window Options

#################################################################################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#################################################################################

#                bash Chroot Options

#################################################################################

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#################################################################################

#                bash Functions

#################################################################################

# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

FUNCTIONS_FILE="$HOME/.bfunctions"

if [ -e $FUNCTIONS_FILE ]; then
	echo "$(date +"%H:%M:%S") -- ~/.bashrc -- Sourcing $FUNCTIONS_FILE..." >> $LOG
      . $FUNCTIONS_FILE
fi

#################################################################################

#                bash Aliases

#################################################################################

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

ALIASES_FILE="$HOME/.aliases"

if [ -f $ALIASES_FILE ]; then
	echo "$(date +%H:%M:%S) -- ~/.bashrc -- Sourcing $ALIASES_FILE..." >> $LOG
   . $ALIASES_FILE
fi

#################################################################################

#                bash Miscellaneous Options

#################################################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# enable vi-style line editing.
set -o vi

# setup gnupg agent
if [ -f "${HOME}/.gnupg/.gpg-agent-info" ]; then
   . "${HOME}/.gnupg/.gpg-agent-info"
   export GPG_AGENT_INFO
#   export SSH_AUTH_SOCK
fi

GPG_TTY=$(tty)
export GPG_TTY

#gpg.env.pl decrypt > /dev/null 2>&1

###############################################################################

#                  Start Applications

###############################################################################

#if [ $(ps -ef |grep -c [d]rop) -eq 0 ]; then
#   f_dropboxConfig
#fi

#if [ $(echo $PATH |grep -c java) -eq 0 ]; then
#   f_javaConfig
#fi

### START-Keychain ###
# Let  re-use ssh-agent and/or gpg-agent between logins
for i in $(ls $HOME/.ssh |grep -v known |grep -v config); do
  /usr/bin/keychain $HOME/.ssh/$i
done
source $HOME/.keychain/$HOSTNAME-sh
### End-Keychain ###

