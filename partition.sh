#!/bin/bash

# Show the current block devices
echo "Current block devices:"
lsblk

# Navigate to the specified directory
cd ./systems/x86_64-linux/ || exit

# Create a numbered list of directories
echo "List of systems:"
i=1
for d in */ ; do
    echo "$i. ${d%/}" # Remove trailing slash
    directories[i++]="${d%/}" # Store directory name without trailing slash
done

# Ask the user to pick a system
read -p "Pick a system by number: " choice

# Validate user input
if [[ ! $choice =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#directories[@]}" ]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

# Run the disko command on the selected directory
selected_directory=${directories[$choice]}
echo "Running disko on $selected_directory..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./systems/x86_64-linux/"$selected_directory"/disks.nix

# Show the block devices after running disko
echo "Block devices after running disko:"
lsblk
