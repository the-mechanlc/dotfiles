export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
else
  echo "oh-my-zsh not found — run install.sh"
fi

# --- Shared aliases (same file as bash) ---
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

# --- History ---
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# --- Environment ---
export HERMES_HOME="${HERMES_HOME:-$HOME}"
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export EDITOR=vim
export KUBECONFIG=~/.kube/config

# --- Local overrides (not tracked) ---
# Create ~/.env.local for machine-specific exports:
#   HERMES_HOME, AWS_REGION, API keys, credentials paths, etc.
if [ -f "$HOME/.env.local" ]; then
  source "$HOME/.env.local"
fi
