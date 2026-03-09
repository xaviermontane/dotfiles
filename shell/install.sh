#!/usr/bin/env bash
set -e

echo "Installing dotfiles..."

packages=(
dev
sec
shell
)

for pkg in "${packages[@]}"; do
    stow -v "$pkg"
done

echo "Dotfiles installed ✔"
