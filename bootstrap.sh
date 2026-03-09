#!/usr/bin/env bash
# ───────────────────────────────────────────────
# Dotfiles Bootstrap (Stow + OS-aware)
# Author: førty
# Description: One-command setup for dotfiles, packages, and environment
# ───────────────────────────────────────────────

set -e
shopt -s nullglob

# ─── Variables ────────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
PACKAGES_DIR="$DOTFILES_DIR/packages"
PACKAGES_COMMON="$PACKAGES_DIR/packages.common.txt"
PACKAGES_OS=""
PACKAGES=""
PACKAGES_LIST=()
PACKAGES_FILE=""
LOG="$HOME/dotfiles_setup.log"
STOW_PACKAGES=(shell sec dev)

echo "[+] Starting dotfiles bootstrap: $(date)" | tee -a "$LOG"

# ─── Detect OS ────────────────────────────────────────────────────────────────
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS_TYPE="linux"; PACKAGES_FILE="$PACKAGES_DIR/packages.linux.txt" ;;
    Darwin*)    OS_TYPE="macos"; PACKAGES_FILE="$PACKAGES_DIR/packages.macos.txt" ;;
    *)          OS_TYPE="unknown"; PACKAGES_FILE="" ;;
esac

echo "[+] Detected OS: $OS_TYPE" | tee -a "$LOG"

if [ "$OS_TYPE" = "unknown" ]; then
    echo "[-] Unsupported OS. Exiting." | tee -a "$LOG"
    exit 1
fi

# ─── SSH Permissions ──────────────────────────────────────────────────────────
if [ -d "$HOME/.ssh" ]; then
    echo "[+] Securing SSH files..." | tee -a "$LOG"
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/config 2>/dev/null || true
    chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
    chmod 644 ~/.ssh/id_rsa.pub 2>/dev/null || true
    chmod 644 ~/.ssh/known_hosts 2>/dev/null || true
    chmod 644 ~/.ssh/authorized_keys 2>/dev/null || true
fi

# ─── Backup Existing Dotfiles ─────────────────────────────────────────────────
echo "[+] Backing up existing dotfiles to $BACKUP_DIR..." | tee -a "$LOG"
mkdir -p "$BACKUP_DIR"

for pkg in "${STOW_PACKAGES[@]}"; do
    SRC="$DOTFILES_DIR/$pkg"
    if [ -d "$SRC" ]; then
        for file in "$SRC"/.*; do
            [ -f "$file" ] || continue
            BASENAME=$(basename "$file")
            DEST="$HOME/$BASENAME"
            [ -f "$DEST" ] && [ ! -L "$DEST" ] && cp "$DEST" "$BACKUP_DIR/"
        done
    fi
done

# ─── Deploy Dotfiles with Stow ───────────────────────────────────────────────
echo "[+] Deploying dotfiles via stow..." | tee -a "$LOG"
for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        stow -v -t "$HOME" "$pkg" | tee -a "$LOG"
    fi
done

# ─── Read Packages ────────────────────────────────────────────────────────────
# Common packages
[ -f "$PACKAGES_COMMON" ] && PACKAGES=$(grep -vE '^\s*#|^\s*$' "$PACKAGES_COMMON")

# OS-specific packages
if [ -f "$PACKAGES_FILE" ]; then
    PACKAGES_OS=$(grep -vE '^\s*#|^\s*$' "$PACKAGES_FILE")
    PACKAGES="$PACKAGES $PACKAGES_OS"
fi

# ─── Install Packages ─────────────────────────────────────────────────────────
if [ -n "$PACKAGES" ]; then
    echo "[+] Installing packages: $PACKAGES" | tee -a "$LOG"

    if [ "$OS_TYPE" = "linux" ]; then
        if command -v apt >/dev/null 2>&1; then
            sudo apt update | tee -a "$LOG"
            sudo apt install -y $PACKAGES | tee -a "$LOG"
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sy --noconfirm $PACKAGES | tee -a "$LOG"
        fi
    elif [ "$OS_TYPE" = "macos" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "[+] Installing Homebrew..." | tee -a "$LOG"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install $PACKAGES | tee -a "$LOG"
    fi
fi

echo "[+] Dotfiles bootstrap completed: $(date)" | tee -a "$LOG"
