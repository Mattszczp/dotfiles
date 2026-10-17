set -gx EDITOR nvim
set -gx BUN_INSTALL $HOME/.bun
set -gx PNPM_HOME $HOME/.local/share/pnpm

fish_add_path -P $HOME/.opencode/bin $BUN_INSTALL/bin $PNPM_HOME $HOME/.local/share/fnm $HOME/.npm-global/bin $HOME/.local/share/bob/nvim-bin $HOME/go/bin $HOME/.local/bin $HOME/.cargo/bin

if status is-interactive
    alias vim nvim

    direnv hook fish | source
    fnm env --use-on-cd --shell fish | source
end

/home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source

set -g fish_greeting
