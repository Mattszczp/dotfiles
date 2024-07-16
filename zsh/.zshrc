export ZSH="$HOME/.oh-my-zsh"
export EDITOR='vim'
ZSH_THEME="robbyrussell"
plugins=(git macos aliases python docker git-auto-fetch golang helm kubectl kubectx tmux zsh-autosuggestions)
alias vim='nvim'
. "$HOME/.cargo/env"
source $ZSH/oh-my-zsh.sh
eval "$(rtx activate zsh)"
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=~/.npm-global/bin:$PATH
