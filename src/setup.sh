#!/bin/bash

sudo pacman -Syu firefox ecryptfs-utils sox # updating and afterwards installing resources
sudo modprobe ecryptfs # loading module
ecryptfs-setup-private # set up private encrypted directory

# setup changed directory
MFILE="$HOME/.ecryptfs/Private.mnt"
if [ -f $MFILE" ]; then
    rm -rf "$MFILE" && cat > "$MFILE" <<< "$HOME/.private"
fi