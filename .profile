export EDITOR=/usr/bin/vim
export VISUAL=$EDITOR

export TERMINAL=/usr/bin/lxterminal
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export XDG_CURRENT_DESKTOP=XFCE
export XDG_CONFIG_DIRS=/etc/xdg

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export HISTFILE=$XDG_CONFIG_HOME/bash/bash_history

export VIMINIT=":source $XDG_CONFIG_HOME"/vim/vimrc
#export VIMDOTDIR=$XDG_CONFIG_HOME/vim

export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc

export LESSKEY=$XDG_CONFIG_HOME/less/lesskey
export LESSHISTFILE=$XDG_CACHE_HOME/less/history

#export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority

# if running bash
#if [ -n $BASH_VERSION ]; then
#	# include .bashrc if it exists
#	if [ -f $XDG_CONFIG_HOME/bash/bashrc ]; then
#		. $XDG_CONFIG_HOME/bash/bashrc
#	fi
#fi
