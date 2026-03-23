#!/usr/bin/env bash
# ───────────────────────────────────────────────
# Dotfiles Bootstrap (Stow + OS-aware)
# Author: førty
# Description: One-command setup for dotfiles, packages, and environment
# ───────────────────────────────────────────────

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG="$HOME/dotfiles_setup.log"

echo "[+] Bootstrap start $(date)" | tee -a "$LOG"

source install/detect.sh
source install/core.sh
source install/storage.sh

echo "[+] Done"