export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source "$ZSH/oh-my-zsh.sh"

# --- History ---
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# --- General Aliases ---
alias c=clear
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l.='ls -d .* --color=auto'
alias ls='ls --color=always'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gl='git log --oneline --graph --decorate'

# --- Git shortcuts ---
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# --- Workspace shortcuts ---
alias ws='cd /data/hermes/workspace/projects'
alias scratch='cd /data/hermes/workspace/scratch'
alias hermes-logs='sudo journalctl -u hermes-gateway -f'
alias hermes-restart='sudo systemctl restart hermes-gateway'
alias hermes-status='sudo systemctl status hermes-gateway'

# --- Kubernetes Aliases ---
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kdn='kubectl describe node'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kdel='kubectl delete'
alias krollout='kubectl rollout'
alias krolloutr='kubectl rollout restart'
alias krollouts='kubectl rollout status'

# --- Kubernetes Context Management ---
alias kcuc='kubectl config use-context'
alias kcgc='kubectl config get-contexts'
alias kccc='kubectl config current-context'

# --- kube-system shortcuts ---
alias kk='kubectl -n kube-system'
alias kkgp='kubectl -n kube-system get pods'
alias kkgs='kubectl -n kube-system get services'
alias kkgd='kubectl -n kube-system get deployments'
alias kkdp='kubectl -n kube-system describe pod'
alias kkds='kubectl -n kube-system describe service'
alias kkdd='kubectl -n kube-system describe deployment'
alias kkl='kubectl -n kube-system logs'
alias kklf='kubectl -n kube-system logs -f'
alias kkex='kubectl -n kube-system exec -it'
alias kkdel='kubectl -n kube-system delete'

# --- Pod Management ---
alias kgpw='kubectl get pods -o wide'
alias kgpall='kubectl get pods --all-namespaces'
alias kgpwatch='kubectl get pods -w'

# --- Environment ---
export HERMES_HOME=/data/hermes
export PATH="$HOME/.local/bin:$HOME/.hermes/node/bin:/usr/local/bin:$PATH"
export EDITOR=vim
export KUBECONFIG=~/.kube/config

# --- Local overrides (not tracked) ---
# Machine-specific env vars (AWS region, credentials, API keys, etc.)
# go in ~/.env.local which is never committed.
if [ -f "$HOME/.env.local" ]; then
  source "$HOME/.env.local"
fi
