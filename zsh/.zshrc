export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
ZSH_THEME="robbyrussell"
plugins=(git macos aliases python docker git-auto-fetch golang helm kubectl kubectx tmux zsh-autosuggestions direnv)
alias vim='nvim'
. "$HOME/.cargo/env"
source $ZSH/oh-my-zsh.sh
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=~/.npm-global/bin:$PATH
export PATH=$HOME/.local/share/fnm:$PATH
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
eval "$(direnv hook zsh)"


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# opencode
export PATH=$HOME/.opencode/bin:$PATH

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Pi
export PATH="/home/kurtwood/.local/share/fnm/node-versions/v25.9.0/installation/bin:$PATH"
