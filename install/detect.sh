OS="$(uname -s)"

case "$OS" in
    Linux*) PLATFORM="linux" ;;
    Darwin*) PLATFORM="macos" ;;
    *) echo "Unsupported OS"; exit 1 ;;
esac

if [ "$PLATFORM" = "linux" ]; then
    if command -v pacman >/dev/null; then
        PKG_MANAGER="pacman"
    elif command -v apt >/dev/null; then
        PKG_MANAGER="apt"
    fi
elif [ "$PLATFORM" = "macos" ]; then
    PKG_MANAGER="brew"
fi
