export ZSH="$HOME/.oh-my-zsh"
export EDITOR='lvim'
ZSH_THEME="robbyrussell"
plugins=(git macos aliases python docker git-auto-fetch golang helm kubectl kubectx tmux zsh-autosuggestions)
alias vim='lvim'
source $ZSH/oh-my-zsh.sh
eval "$(rtx activate zsh)"