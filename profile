# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

#################################################################################

#                Local Variables

#################################################################################

echo "Setting .profile variables..."
LOGDIR="$HOME/.logs"
LOG="$LOGDIR/session.log"
# Initialize log
if [ ! -d $LOGDIR ]; then
  mkdir $LOGDIR
fi
echo "$(date +"%Y-%m-%d %H:%M:%S") -- ~/.profile -- Session Started ..." > $LOG
PRIVBIN="$HOME/.bin"

##################################################################

#######          User-Based Configuration

echo "Choosing shell configuration for $SHELL..."
echo "$(date +%H:%M:%S) -- ~/.profile -- Running $SHELL" >> $LOG

case $(basename $SHELL) in
   bash)
     SHELL_CONFIG="$HOME/.bashrc"
   ;;
   ksh)
     SHELL_CONFIG="$HOME/.kshrc"
   ;;
   zsh)
     SHELL_CONFIG="$HOME/.zshrc"
   ;;
   *)
   ;;
esac

if [ -f "$SHELL_CONFIG" ]; then
   echo "$(date +%H:%M:%S) -- ~/.profile -- Sourcing $SHELL_CONFIG" >> $LOG
   . $SHELL_CONFIG
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$PRIVBIN" ] ; then
#   PATH=$PRIVBIN:$(echo $PRIVBIN/**/ | sed 's/\s\s*/:/g'):$PATH
   echo "$(date +"%H:%M:%S") -- ~/.profile -- Adding private bin to \$PATH" >> $LOG
   export PATH="$PRIVBIN:$PATH"
fi


##################################################################

#######          OS-Based Configuration



#export LOCALENV="/dev/shm/localenv"
#echo "none" > $LOCALENV
#touch $LOCALENV

#eval $(gpg-agent --daemon)
#gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gnupg/.gpg-agent-info"
gpg-agent --daemon --write-env-file "${HOME}/.gnupg/.gpg-agent-info" >> $LOG
