#!/usr/bin/env bash
# install-tools.sh — install CLI tools used in this dotfiles setup
# Supports Debian/Ubuntu only (uses dpkg for arch detection)

set -euo pipefail

# --- Guard: Debian/Ubuntu only ---
if ! command -v dpkg &>/dev/null; then
  echo "ERROR: This script requires dpkg (Debian/Ubuntu). Exiting."
  exit 1
fi

ARCH=$(dpkg --print-architecture)
echo "==> Detected architecture: $ARCH"

# --- kubectl ---
if ! command -v kubectl &>/dev/null; then
  echo "==> Installing kubectl..."
  KUBECTL_VER=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
  curl -fsSLo /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VER}/bin/linux/${ARCH}/kubectl"
  chmod +x /tmp/kubectl && sudo mv /tmp/kubectl /usr/local/bin/
  echo "  kubectl $(kubectl version --client --short 2>/dev/null || kubectl version --client) ✓"
else echo "  kubectl already installed"; fi

# --- helm ---
if ! command -v helm &>/dev/null; then
  echo "==> Installing helm..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o /tmp/get-helm.sh
  chmod +x /tmp/get-helm.sh && /tmp/get-helm.sh
  rm -f /tmp/get-helm.sh
  echo "  helm $(helm version --short) ✓"
else echo "  helm already installed"; fi

# --- eksctl ---
if ! command -v eksctl &>/dev/null; then
  echo "==> Installing eksctl..."
  TMPDIR=$(mktemp -d)
  curl -fsSL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz" | tar xz -C "$TMPDIR"
  sudo mv "$TMPDIR/eksctl" /usr/local/bin/
  rm -rf "$TMPDIR"
  echo "  eksctl $(eksctl version) ✓"
else echo "  eksctl already installed"; fi

# --- kubectx + kubens ---
if ! command -v kubectx &>/dev/null; then
  echo "==> Installing kubectx & kubens..."
  TMPDIR=$(mktemp -d)
  git clone --depth 1 --single-branch https://github.com/ahmetb/kubectx "$TMPDIR/kubectx"
  sudo cp "$TMPDIR/kubectx/kubectx" /usr/local/bin/kubectx
  sudo cp "$TMPDIR/kubectx/kubens"  /usr/local/bin/kubens
  sudo chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens
  rm -rf "$TMPDIR"
  echo "  kubectx + kubens ✓"
else echo "  kubectx already installed"; fi

# --- k9s ---
if ! command -v k9s &>/dev/null; then
  echo "==> Installing k9s..."
  K9S_VER=$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d'"' -f4)
  TMPDIR=$(mktemp -d)
  curl -fsSL "https://github.com/derailed/k9s/releases/download/${K9S_VER}/k9s_Linux_${ARCH}.tar.gz" | tar xz -C "$TMPDIR"
  sudo mv "$TMPDIR/k9s" /usr/local/bin/
  rm -rf "$TMPDIR"
  echo "  k9s $(k9s version --short 2>/dev/null | head -1) ✓"
else echo "  k9s already installed"; fi

# --- stern ---
if ! command -v stern &>/dev/null; then
  echo "==> Installing stern..."
  STERN_VER=$(curl -fsSL https://api.github.com/repos/stern/stern/releases/latest | grep tag_name | cut -d'"' -f4)
  TMPDIR=$(mktemp -d)
  curl -fsSL "https://github.com/stern/stern/releases/download/${STERN_VER}/stern_${STERN_VER#v}_linux_${ARCH}.tar.gz" | tar xz -C "$TMPDIR"
  sudo mv "$TMPDIR/stern" /usr/local/bin/
  rm -rf "$TMPDIR"
  echo "  stern $(stern --version) ✓"
else echo "  stern already installed"; fi

# --- gh CLI ---
if ! command -v gh &>/dev/null; then
  echo "==> Installing gh CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get update -q && sudo apt-get install -y gh
  echo "  gh $(gh --version | head -1) ✓"
else echo "  gh already installed"; fi

echo ""
echo "All tools installed successfully."
