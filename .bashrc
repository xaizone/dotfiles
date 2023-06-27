#
# ~/.bashrc
#

## EXPORTS ##
export TERM="xterm-256color"
export HISTCONTROL=ignoredups:erasedups

[[ $- != *i* ]] && return

## QOL ##

# SHOPT
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s histappend
shopt -s checkwinsize
shopt -s no_empty_cmd_completion

# OTHER
bind "set completion-ignore-case on"
set -o noclobber

## ALIASES ##

# GENERAL
alias vim='nvim'
alias nano='nvim'

# LS
alias ls='ls --color=always'
alias la='ls -a --color=always'
alias lal='ls -al --color=always'

# PACMAN
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# FLAGS
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias grep='grep --color=auto'

# GIT
alias lg='lazygit'
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# USER
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

## ARCHIVE EXTRACTION ##
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

## CHANGE TERMINAL TITLE ##
case ${TERM} in xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"';;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"';;
esac

## PROMPT ##
PS1='\[\e[0;91m\][\[\e[0;93m\]\u\[\e[0;92m\]@\[\e[0;94m\]\h \[\e[0;35m\]\w\[\e[0;91m\]]\[\e[0m\]\$ \[\e[0m\]'
