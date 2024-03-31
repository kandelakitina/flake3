#!/bin/bash

# 1. Show lsblk
echo "Current block devices:"
lsblk
echo ""

# 2. Show a list of folders in .systems/x86_64-linux as a numbered list
echo "Available systems:"
cd .systems/x86_64-linux
select folder in */; do
    if [ -n "$folder" ]; then
        break
    else
        echo "Invalid selection, please try again."
    fi
done
cd - > /dev/null

# Removing the trailing slash for use in the nix command
folder=${folder%/}

# 3. The 'select' command handles asking the user to pick a system and uses the selection.

# 4. Run the nix command
echo "Running disko on $folder..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ".systems/x86_64-linux/$folder/disks.nix"

# 5. Show lsblk after disko does its job
echo "Block devices after disko:"
lsblk
