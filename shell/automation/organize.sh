#!/bin/bash

DIR="$HOME/downloads"

# Organize elements within the downloads folder
for file in "$DIR"/*; do
    if [[ -f "$file" ]]; then
        extension="${file##*.}"
        
        # Define the folder to move the file based on its extension
        case "$extension" in 
            "txt")
                folder="$DIR/text"
                ;;
            "jpg"|"jpeg"|"png")
                folder="$DIR/images"
                ;;
            "pdf")
                folder="$DIR/pdf"
                ;;
            "deb")
                folder="$DIR/packs"
                ;;
            "tar"|"gz"|"tgz")
                folder="$DIR/compressed"
                ;;
            *)
                folder="$DIR/other"
                ;;
        esac
        
        # Create the target folder if it doesn't exist
        mkdir -p "$folder"
        
        # Move the file to the corresponding folder
        mv "$file" "$folder"
        
        # Display the correct folder in output
        echo "Moved $(basename "$file") to $folder"
    fi
done
