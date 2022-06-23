export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
ZSH_THEME="robbyrussell"
plugins=(git macos iterm2 aliases python docker git-auto-fetch golang helm kubectl kubectx tmux)
alias vim='nvim'

source $ZSH/oh-my-zsh.sh
if [ $(uname -r | grep "microsoft") ];
then
    export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
    ss -a | grep -q $SSH_AUTH_SOCK
    if [ $? -ne 0   ]; then
        rm -f $SSH_AUTH_SOCK
        ( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$HOME/winhome/.wsl/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & )
    fi
fi

export NVM_DIR="$HOME/.nvm"

if [ $(uname -r | grep "Darwin") ];
then
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    export NVM_DIR="/opt/homebrew/opt/nvm/"
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
    export PATH="/System/Volumes/Data/Users/Shared/DBngin/postgresql/12.2/bin/pg_config:$PATH"
    export PATH="/opt/homebrew/Cellar/openssl@3/3.0.2/bin/openssl:$PATH"

    export ANDROID_HOME=$HOME/Library/Android/sdk
    export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib -L/opt/homebrew/opt/libpq/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include -I/opt/homebrew/opt/libpq/include"
fi


export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"


[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

export PATH="$HOME/.gvm/bin:$PATH"
alias py="python"
export GOPATH=$HOME/personal/go
export PATH=$PATH:$GOPATH/bin
