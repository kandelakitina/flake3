#!/bin/bash

# Step 1: Show 'lsblk'
echo "Current block devices:"
lsblk
echo

# Step 2: Show a list of folders in .systems/x86_64-linux as a numbered list
echo "Available systems:"
i=1
for folder in .systems/x86_64-linux/*; do
    if [ -d "$folder" ]; then
        echo "$i. $(basename "$folder")"
        directoryMap[$i]="$folder"
        ((i++))
    fi
done
echo

# Step 3: Ask the user to pick a system
read -p "Pick a system (Enter the number): " choice

# Validate input
re='^[0-9]+$'
if ! [[ $choice =~ $re ]] ; then
   echo "Error: Not a number" >&2; exit 1
fi

if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#directoryMap[@]}" ]; then
    echo "Error: Choice out of range." >&2
    exit 1
fi

selectedFolder=${directoryMap[$choice]}
echo "You selected: $(basename "$selectedFolder")"
echo

# Step 4: Run the specified command
echo "Running disko on the selected system..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "$selectedFolder/disks.nix"
echo

# Step 5: Show `lsblk` after disko does its job
echo "Block devices after running disko:"
lsblk
