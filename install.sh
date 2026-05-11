#!/usr/bin/env bash
# install.sh — bootstrap dotfiles by symlinking into $HOME
# Backs up any existing file before replacing it.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

backup_and_link() {
  local src="$1"
  local dest="$2"

  # Catch both real files and dangling symlinks
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "  Backing up $dest → $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi

  ln -sf "$src" "$dest"
  echo "  Linked $dest → $src"
}

echo "==> Dotfiles dir: $DOTFILES_DIR"
echo ""

# --- Shell configs ---
echo "==> Linking shell configs..."
backup_and_link "$DOTFILES_DIR/zsh/.zshrc"        "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/bash/.bashrc"       "$HOME/.bashrc"
backup_and_link "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"

# --- Git ---
echo "==> Linking git config..."
backup_and_link "$DOTFILES_DIR/git/.gitconfig"       "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# --- Vim ---
echo "==> Linking vim config..."
backup_and_link "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

# --- Tmux ---
echo "==> Linking tmux config..."
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# --- oh-my-zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo ""
  echo "==> Installing oh-my-zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> oh-my-zsh already installed, skipping."
fi

# --- zsh plugins ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "==> Installing zsh-syntax-highlighting..."
  git clone --depth 1 --single-branch https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "==> zsh-syntax-highlighting already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "==> Installing zsh-autosuggestions..."
  git clone --depth 1 --single-branch https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "==> zsh-autosuggestions already installed."
fi

echo ""
echo "==> Done! Open a new shell or run: source ~/.zshrc"
echo ""
echo "Post-install steps:"
echo "  1. Set your git email:  git config --global user.email \"you@example.com\""
echo "  2. Create ~/.env.local for machine-specific exports (AWS region, API keys, etc.)"
echo "  3. Optional: run scripts/install-tools.sh to install CLI tools"
