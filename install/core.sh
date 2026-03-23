echo "Installing core tools..."

install_packages() {

while read package; do

if [[ "$PLATFORM" == "macos" ]]; then
brew install "$package"

elif [[ "$PLATFORM" == "arch" ]]; then
sudo pacman -S --needed --noconfirm "$package"

elif [[ "$PLATFORM" == "ubuntu" ]]; then
sudo apt install -y "$package"

fi

done < install/lists/core.txt

}

install_packages