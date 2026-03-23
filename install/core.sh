echo "[+] Running core setup"

backup_dotfiles() {
    mkdir -p "$BACKUP_DIR"
}

deploy_dotfiles() {
    for pkg in "${STOW_PACKAGES[@]}"
    do
        stow -t "$HOME" "$pkg"
    done
}

install_packages() {
    FILE=$1

    [ -f "$FILE" ] || return

    while read pkg
    do
        [[ "$pkg" =~ ^#.*$ ]] && continue

        if [ "$PKG_MANAGER" = "pacman" ]; then
            sudo pacman -S --needed --noconfirm "$pkg"
        elif [ "$PKG_MANAGER" = "apt" ]; then
            sudo apt install -y "$pkg"
        elif [ "$PKG_MANAGER" = "brew" ]; then
            brew install "$pkg"
        fi
    done < "$FILE"
}

install_packages packages/core.txt
install_packages packages/dev.txt
