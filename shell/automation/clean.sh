#!/bin/bash

DIR="/tmp"

# Find files that have not been accessed in the last 30 days and delete them
find "$DIR" -type f -atime +30 -exec rm -f {} \;

echo "Files in $DIR not accessed in the last 30 days have been deleted."
