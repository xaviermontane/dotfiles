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
LOG="$HOME/dotfiles_setup.log"
STOW_PACKAGES=(shell sec dev)

echo "[+] Bootsrap started $(date)" | tee -a "$LOG"

# ─── Detect OS ────────────────────────────────────────────────────────────────
OS="$(uname -s)"

case "$OS" in
Linux*) OS_TYPE="linux" ;;
Darwin*) OS_TYPE="macos" ;;
*) OS_TYPE="unknown" ;;
esac

echo "[+] Detected OS: $OS_TYPE" | tee -a "$LOG"

if [ "$OS_TYPE" = "unknown" ]; then
    echo "[-] Unsupported OS. Exiting." | tee -a "$LOG"
    exit 1
fi

# ─── Package manager detection ─────────────────────────────

if [ "$OS_TYPE" = "linux" ]; then
    if command -v pacman >/dev/null; then
        PKG_MANAGER="pacman"
    elif command -v apt >/dev/null; then
        PKG_MANAGER="apt"
    fi

elif [ "$OS_TYPE" = "macos" ]; then
    PKG_MANAGER="brew"
fi

echo "[+] Package manager: $PKG_MANAGER" | tee -a "$LOG"

# ─── Install Homebrew if needed ────────────────────────────

if [ "$PKG_MANAGER" = "brew" ]; then
    if ! command -v brew >/dev/null; then
        echo "[+] Installing Homebrew" | tee -a "$LOG"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

# ─── SSH Permissions ──────────────────────────────────────────────────────────
if [ -d "$HOME/.ssh" ]; then
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/* 2>/dev/null || true
fi

# ─── Backup Existing Dotfiles ─────────────────────────────────────────────────
mkdir -p "$BACKUP_DIR"

for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        for file in "$DOTFILES_DIR/$pkg"/.*; do
            [ -f "$file" ] || continue
            name=$(basename "$file")
            target="$HOME/$name"
            if [ -f "$target" ] && [ ! -L "$target" ]; then
                cp "$target" "$BACKUP_DIR/"
            fi
        done
    fi
done

# ─── Deploy Dotfiles with Stow ───────────────────────────────────────────────
for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        stow -v -t "$HOME" "$pkg" | tee -a "$LOG"
    fi
done

# ─── Package install function ───────────────────────────────────────────────

install_list() {
    FILE=$1
    [ -f "$FILE" ] || return
    while read package; do
        [[ "$package" =~ ^#.*$ ]] && continue
        [[ -z "$package" ]] && continue

        echo "[+] Installing $package" | tee -a "$LOG"
        if [ "$PKG_MANAGER" = "pacman" ]; then
            sudo pacman -S --needed --noconfirm "$package"
        elif [ "$PKG_MANAGER" = "apt" ]; then
            sudo apt install -y "$package"
        elif [ "$PKG_MANAGER" = "brew" ]; then
            brew install "$package"
        fi
    done < "$FILE"
}

# ─── Install package groups (NEW STRUCTURE) ─────────────────

echo "[+] Installing core packages" | tee -a "$LOG"
install_list "$PACKAGES_DIR/core.txt"

echo "[+] Installing dev packages"
install_list "$PACKAGES_DIR/dev.txt"

echo "[+] Installing network packages"
install_list "$PACKAGES_DIR/network.txt"

echo "[+] Installing OS specific"
install_list "$PACKAGES_DIR/packages.$OS_TYPE.txt"

# Optional lab install prompt
echo "Install lab tools? (y/n)"

read LAB

if [[ "$LAB" == "y" ]]; then
    install_list "$PACKAGES_DIR/lab.txt"
fi

# ─── Storage integration hook (NEW) ────────────────────────

if [ -d "/mnt/homelab" ]; then
    mkdir -p /mnt/homelab/{vm,pcap,tools,backup}
elif [ -d "/Volumes/homelab" ]; then
    mkdir -p /Volumes/homelab/{vm,pcap,tools,backup}
fi

echo "[+] Bootstrap complete $(date)" | tee -a "$LOG"