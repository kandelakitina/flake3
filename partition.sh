#!/bin/bash

# 1. Show 'lsblk'
lsblk
echo ""

# 2. Show a list of folders in ./systems/x86_64-linux as a numbered list
echo "List of systems:"
i=1
for folder in ./systems/x86_64-linux/*; do
    if [ -d "$folder" ]; then
        echo "$i. $(basename "$folder")"
        let i++
    fi
done

# 3. Ask the user to pick a system
echo "Pick a system: "
read -r choice

# Validate input
folders=(./systems/x86_64-linux/*)
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#folders[@]}" ]; then
    echo "Invalid selection."
    exit 1
fi

# 4. Run the specified command with the selected folder
selected_folder=$(basename "${folders[$choice-1]}")
echo "Running disko for $selected_folder..."

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "./systems/x86_64-linux/$selected_folder/disks.nix"

# 5. Show `lsblk` after disko does its job
echo "Final lsblk state:"
lsblk
