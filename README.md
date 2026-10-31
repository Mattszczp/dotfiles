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

## Agents

`dot_agents/skills/` is the source for agent skills, deployed to `~/.agents/skills`. Claude Code only reads `~/.claude/skills`, which chezmoi links to `~/.agents/skills`, so both see the same skills.

## Development

```sh
pre-commit install              # enable hooks once per clone
pre-commit run --all-files      # run hooks against every file
```
