# dotfiles

Chezmoi-managed dotfiles. The repo is the chezmoi source dir.

## Install

```sh
brew install chezmoi

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
