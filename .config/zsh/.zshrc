# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aliervo/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

fpath+=$XDG_CONFIG_HOME/zsh/pure

autoload -U promptinit; promptinit
prompt pure

alias dotfiles="$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

typeset -U path PATH
path=($VOLTA_HOME/bin $path)
export PATH
