# dotfiles

Chezmoi-managed dotfiles. The repo is the chezmoi source dir.

## Install

macOS:

```sh
brew install chezmoi pre-commit go
```

Fedora:

```sh
sudo dnf install chezmoi pre-commit golang ghostty fish tmux
```

Then deploy:

```sh
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<'EOF'
sourceDir = "~/.dotfiles"
EOF

git clone <repo-url> ~/.dotfiles
chezmoi init
chezmoi apply
```

## Daily use

```sh
chezmoi apply            # deploy changes to home
chezmoi status           # what differs (exit 1 + output = out of sync)
```

## Development

```sh
pre-commit install              # enable hooks once per clone
pre-commit run --all-files      # run hooks against every file
```
