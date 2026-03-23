echo "[+] Checking storage"

if [ -d "/mnt/homelab" ]; then
    LAB_ROOT="/mnt/homelab"
elif [ -d "/Volumes/homelab" ]; then
    LAB_ROOT="/Volumes/homelab"
fi

if [ -n "$LAB_ROOT" ]; then
    echo "[+] Found lab storage"
    mkdir -p $LAB_ROOT/{vm,pcap,tools,backup}
    export LAB_ROOT
fi
