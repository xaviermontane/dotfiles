#!/bin/bash

DIR="downloads/"

# Organize elements within the downloads folder
for file in "$DIR"/*; do
	if [[ -f "$file" ]]; then
		extension="${file##*.}"
		case "$extension" in 
			"txt")
				echo "Processing text file: $file"
				;;
			"jpg|jpeg|png")
				echo "Processing an image file: $file"
				;;
			"pdf")
				echo "Processing a PDF file: $file"
				;;
			"deb")
				echo "Processing a package file: $file"
				;;
			"tar|gz|tgz")
				echo "Processing a compressed file: $file"
				;;
			*)
				echo "Skipping file with unknown extension: $file"
				;;
		esac
	fi
done
