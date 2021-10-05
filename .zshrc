export _JAVA_AWT_WM_NONREPARENTING=1
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd extendedglob nomatch
unsetopt beep
bindkey -e

zstyle :compinstall filename '/home/noah/.zshrc'

autoload -Uz compinit
compinit

alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -l --color=auto"
alias l.="ls -a | grep \"^\.\""

alias cleanup="sudo pacman -Rns (pacman -Qtdq)"

alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

alias grep='grep --color=auto'

alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias df="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"

neofetch
eval "$(starship init zsh)"
