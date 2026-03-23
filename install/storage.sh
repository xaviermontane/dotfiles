echo "Checking lab storage..."

if [ -d "/Volumes/homelab" ]; then
export LAB="/Volumes/homelab"

elif [ -d "/mnt/homelab" ]; then
export LAB="/mnt/homelab"

fi