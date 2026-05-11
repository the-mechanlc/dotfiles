#!/usr/bin/env bash
# install-tools.sh — install CLI tools used in this dotfiles setup
# Supports Debian/Ubuntu only (uses dpkg for arch detection)

set -euo pipefail

# --- Cleanup trap ---
_tmpdir=""
_cleanup() { [ -n "$_tmpdir" ] && rm -rf "$_tmpdir"; }
trap _cleanup EXIT

# --- Guards ---
if ! command -v dpkg &>/dev/null; then
  echo "ERROR: This script requires dpkg (Debian/Ubuntu). Exiting."
  exit 1
fi

if ! command -v curl &>/dev/null || ! command -v git &>/dev/null; then
  echo "==> Installing curl and git prerequisites..."
  sudo apt-get update -q && sudo apt-get install -y curl git
fi

ARCH=$(dpkg --print-architecture)
echo "==> Detected architecture: $ARCH"

# Helper: get latest GitHub release tag safely
latest_github_release() {
  local repo="$1"
  local tag
  tag=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
  if [ -z "$tag" ]; then
    echo "ERROR: Could not determine latest release for ${repo}" >&2
    exit 1
  fi
  echo "$tag"
}

# --- kubectl ---
if ! command -v kubectl &>/dev/null; then
  echo "==> Installing kubectl..."
  KUBECTL_VER=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
  curl -fsSLo /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VER}/bin/linux/${ARCH}/kubectl"
  chmod +x /tmp/kubectl && sudo mv /tmp/kubectl /usr/local/bin/
  echo "  kubectl ${KUBECTL_VER} ✓"
else echo "  kubectl already installed"; fi

# --- helm ---
if ! command -v helm &>/dev/null; then
  echo "==> Installing helm..."
  _tmpdir=$(mktemp -d)
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o "$_tmpdir/get-helm.sh"
  chmod +x "$_tmpdir/get-helm.sh" && "$_tmpdir/get-helm.sh"
  _tmpdir=""  # reset so trap doesn't try to delete already-cleaned dir
  echo "  helm ✓"
else echo "  helm already installed"; fi

# --- eksctl ---
if ! command -v eksctl &>/dev/null; then
  echo "==> Installing eksctl..."
  _tmpdir=$(mktemp -d)
  curl -fsSL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz" | tar xz -C "$_tmpdir"
  sudo mv "$_tmpdir/eksctl" /usr/local/bin/
  rm -rf "$_tmpdir"; _tmpdir=""
  echo "  eksctl $(eksctl version) ✓"
else echo "  eksctl already installed"; fi

# --- kubectx + kubens ---
if ! command -v kubectx &>/dev/null; then
  echo "==> Installing kubectx & kubens..."
  _tmpdir=$(mktemp -d)
  git clone --depth 1 --single-branch https://github.com/ahmetb/kubectx "$_tmpdir/kubectx"
  sudo cp "$_tmpdir/kubectx/kubectx" /usr/local/bin/kubectx
  sudo cp "$_tmpdir/kubectx/kubens"  /usr/local/bin/kubens
  sudo chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens
  rm -rf "$_tmpdir"; _tmpdir=""
  echo "  kubectx + kubens ✓"
else echo "  kubectx already installed"; fi

# --- k9s ---
if ! command -v k9s &>/dev/null; then
  echo "==> Installing k9s..."
  K9S_VER=$(latest_github_release "derailed/k9s")
  _tmpdir=$(mktemp -d)
  curl -fsSL "https://github.com/derailed/k9s/releases/download/${K9S_VER}/k9s_Linux_${ARCH}.tar.gz" | tar xz -C "$_tmpdir"
  sudo mv "$_tmpdir/k9s" /usr/local/bin/
  rm -rf "$_tmpdir"; _tmpdir=""
  echo "  k9s ${K9S_VER} ✓"
else echo "  k9s already installed"; fi

# --- stern ---
if ! command -v stern &>/dev/null; then
  echo "==> Installing stern..."
  STERN_VER=$(latest_github_release "stern/stern")
  _tmpdir=$(mktemp -d)
  curl -fsSL "https://github.com/stern/stern/releases/download/${STERN_VER}/stern_${STERN_VER#v}_linux_${ARCH}.tar.gz" | tar xz -C "$_tmpdir"
  sudo mv "$_tmpdir/stern" /usr/local/bin/
  rm -rf "$_tmpdir"; _tmpdir=""
  echo "  stern ${STERN_VER} ✓"
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
