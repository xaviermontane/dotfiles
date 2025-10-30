# !/bin/bash

# ───────────────────────────────────────────────
# Dotfiles Setup Script
# Author: førty
# Description: Sets up a consistent environment across systems.
# ───────────────────────────────────────────────

set -e
shopt -s nullglob

# ─── Variables ────────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
SHELL_FILES=(.bashrc .bash_aliases .bash_profile .bash_prompt)
CONFIG_DIRS=(shell sec dev)
LOG="$HOME/dotfiles_setup.log"

# ─── Logging ─────────────────────────────────────────────────────────────────
echo "Starting dotfiles setup: $(date)" | tee -a "$LOG"

# ─── SSH Permissions ─────────────────────────────────────────────────────────
if [ -d "$HOME/.ssh" ]; then
    echo "[+] Securing SSH files..." | tee -a "$LOG"
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/config 2>/dev/null || true
    chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
    chmod 644 ~/.ssh/id_rsa.pub 2>/dev/null || true
    chmod 644 ~/.ssh/known_hosts 2>/dev/null || true
    chmod 644 ~/.ssh/authorized_keys 2>/dev/null || true
fi

# ─── Local Backup Existing Configs ─────────────────────────────────────────────────
echo "[+] Backing up existing configs to $BACKUP_DIR..." | tee -a "$LOG"
mkdir -p "$BACKUP_DIR"

for file in "${SHELL_FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        mv "$HOME/$file" "$BACKUP_DIR/" && echo "  ↳ $file backed up" | tee -a "$LOG"
    fi
done

# ─── Symlink or Copy Dotfiles ────────────────────────────────────────────────
echo "[+] Deploying dotfiles..." | tee -a "$LOG"
for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$DOTFILES_DIR/$dir"
    if [ -d "$SRC" ]; then
        for file in "$SRC"/.*; do
            [ -f "$file" ] || continue
            BASENAME=$(basename "$file")
            DEST="$HOME/$BASENAME"
            # Backup existing file if it exists
            [ -f "$DEST" ] && [ ! -L "$DEST" ] && cp "$DEST" "$BACKUP_DIR/"
        if ln -sf "$file" "$DEST"; then
            echo "  ↳ Linked $BASENAME → $DEST" | tee -a "$LOG"
        else
            echo "  ✗ Failed to link $BASENAME" | tee -a "$LOG"
        fi
        done
    fi
done

# ─── Install Packages (optional) ─────────────────────────────────────────────
if command -v apt >/dev/null 2>&1; then
    echo "[+] Installing packages (Debian-based)..." | tee -a "$LOG"
    sudo apt update && sudo apt install -y git curl vim
elif command -v pacman >/dev/null 2>&1; then
    echo "[+] Installing packages (Arch-based)..." | tee -a "$LOG"
    sudo pacman -Syu --noconfirm git curl vim
elif command -v brew >/dev/null 2>&1; then
    echo "[+] Installing packages (macOS)..." | tee -a "$LOG"
    brew install git curl vim
elif command -v choco >/dev/null 2>&1; then
    echo "[+] Installing packages (Windows)..." | tee -a "$LOG"
    choco install -y git curl vim
else
    echo "[!] No recognized package manager found. Skipping package installation." | tee -a "$LOG"
fi

# ─── Final Output ───────────────────────────────────────────────────────────
echo "✔ Dotfiles setup completed successfully!"
echo "All backups stored in: $BACKUP_DIR"
echo "Log saved to: $LOG"