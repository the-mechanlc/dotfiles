# ~/.bashrc — sourced for interactive non-login shells

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# --- History ---
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# --- Window size ---
shopt -s checkwinsize

# --- Color prompt ---
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# --- Color support ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# --- Aliases ---
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# --- Bash completion ---
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

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
