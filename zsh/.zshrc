export ZSH="$HOME/.oh-my-zsh"
export EDITOR='vim'
ZSH_THEME="robbyrussell"
plugins=(git macos aliases python docker git-auto-fetch golang helm kubectl kubectx tmux zsh-autosuggestions direnv)
alias vim='nvim'
. "$HOME/.cargo/env"
source $ZSH/oh-my-zsh.sh
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=~/.npm-global/bin:$PATH
eval "$(direnv hook zsh)"


# bun completions
[ -s "/Users/matts/.bun/_bun" ] && source "/Users/matts/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"

# opencode
export PATH=/Users/matts/.opencode/bin:$PATH
