# dotfiles

Personal dotfiles for shell, git, vim, and tmux — managed with symlinks via `install.sh`.

## What's Included

| Path | Description |
|------|-------------|
| `zsh/.zshrc` | Zsh config — oh-my-zsh, agnoster theme, sources shared aliases |
| `bash/.bashrc` | Bash config — history, PATH, sources shared aliases |
| `bash/.bash_aliases` | Shared aliases for both bash and zsh (general, git, kubernetes) |
| `git/.gitconfig` | Git config — editor, pull strategy, useful aliases |
| `git/.gitignore_global` | Global gitignore — editor artifacts, OS files, secrets |
| `vim/.vimrc` | Vim config — sensible defaults, persistent undo, split navigation |
| `tmux/.tmux.conf` | Tmux config — mouse, vi mode, splits, status bar |
| `scripts/install-tools.sh` | Installs CLI tools: kubectl, helm, eksctl, k9s, stern, gh |

## Install

```bash
git clone https://github.com/the-mechanlc/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

`install.sh` will:
- Symlink all dotfiles into `$HOME` (backs up existing files to `~/.dotfiles_backup/`)
- Install oh-my-zsh if not present
- Install `zsh-syntax-highlighting` and `zsh-autosuggestions` plugins

## Install CLI Tools (optional)

```bash
chmod +x scripts/install-tools.sh
./scripts/install-tools.sh
```

Installs: `kubectl`, `helm`, `eksctl`, `kubectx`, `kubens`, `k9s`, `stern`, `gh`

> **Note:** Requires Debian/Ubuntu (uses `dpkg` for architecture detection).

## Post-Install Steps

1. **Set your git identity:**
   ```bash
   git config --global user.name  "Your Name"
   git config --global user.email "you@example.com"
   ```

2. **Create `~/.env.local`** for machine-specific exports that shouldn't be committed:
   ```bash
   # ~/.env.local — not tracked by git
   export HERMES_HOME=/your/hermes/path   # defaults to $HOME if unset
   export AWS_REGION=us-east-1
   export AWS_DEFAULT_REGION=us-east-1
   # Add any other machine-specific vars here
   ```
   Both `.zshrc` and `.bashrc` will auto-source this file if it exists.

3. **Configure AWS credentials** (if using AWS tools):
   ```bash
   aws configure
   ```
