#!/usr/bin/env bash
set -euo pipefail

# Claude Code
sudo npm install -g @anthropic-ai/claude-code

# GitLab CLI (glab)
ARCH="$(dpkg --print-architecture)"
GLAB_VERSION="$(curl -fsSL 'https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases?per_page=1' \
  | grep -oP '"tag_name":"v\K[^"]+' | head -n1)"
curl -fsSL \
  "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_${ARCH}.deb" \
  -o /tmp/glab.deb
sudo apt-get install -y /tmp/glab.deb
rm /tmp/glab.deb

# zsh plugins (oh-my-zsh installed by common-utils feature)
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
for repo in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
  dest="${ZSH_CUSTOM}/plugins/${repo}"
  [ -d "$dest" ] || git clone --depth 1 "https://github.com/zsh-users/${repo}" "$dest"
done

sed -i 's|^plugins=.*|plugins=(git npm node gh docker zsh-autosuggestions zsh-syntax-highlighting zsh-completions)|' \
  "${HOME}/.zshrc"

# Project deps
npm install
