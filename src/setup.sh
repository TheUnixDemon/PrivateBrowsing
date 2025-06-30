#!/bin/bash

# installs dependencies and sets up private directory
makeInstall() {
    echo "Required packages ..."
    sudo pacman -Syu --noconfirm firefox ecryptfs-utils sox # updating and afterwards installing resources

    echo "Loading kernel module ..."
    sudo modprobe ecryptfs # loading module

    echo "Setup private directory ..."
    ecryptfs-setup-private # set up private encrypted directory
    exit 0
}

# creates log files
createLog() {
    local path=$1
    if [[ ! -f $path ]]; then
        touch $path
    fi
}

# checks if ercyptfs is setup right
if [[ ! $MOUNTDIR ]]; then
    if [[ -f "$MOUNTFILE" && -f "$KEYFILE" ]]; then
        export MOUNTDIR=$(cat "$MOUNTFILE")
    else
        if [[ "$SHLVL" -lt 2 ]]; then
            echo "*$MOUNTFILE* & *$KEYFILE* not found - Setup installation initialized"
            makeInstall
        fi
    fi
fi

# creates non existing log files outside of private directory
createLog "$APPLOG"