#!/bin/bash

# sound notificatibased with *sox*
notification() {
    local rounds=${2:-1} # -1 -> default is ones
    if [[ $SOUND == "true" ]]; then
        (
            for  (( i = 0; i < rounds; i++ )); do
                play -n synth 0.3 sin 880 fade q 0.05 0.3 0.1 vol 0.2 > /dev/null 2>&1
            done
        ) & disown
    fi
}

# mount private dir (interactive)
mountDir() {
    echo "$(tput setaf 1)< $(tput sgr0) Mounting encrypted directory at *$MOUNTDIR* $(tput setaf 1) >$(tput sgr0)"
    while true; do
        read -p "Confirm? (y/N) " answer
        case $answer in
            y|Y)
                if ecryptfs-mount-private && mountpoint -q "$MOUNTDIR"; then
                    break
                else # error accurred
                    exit 1
                fi
            ;;
            n|N)
                exit 0
            ;;
            *)
            continue
            ;;
        esac
    done
}

unmountDir() {
    local TIME=$1
    while true; do
        sleep $TIME
        if ! lsof +D "$MOUNTDIR" >> $APPLOG 2>&1; then
            if ! ecryptfs-umount-private; then # unmount failed
                continue
            fi
            notification 2
            exit 0
        fi
    done
}

# environment variables & setup
WORKINGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # location of bash script
source "$WORKINGDIR/env.sh" # basic environment variables (file locations)
source "$WORKINGDIR/setup.sh" # locate mounting directory and setup checked

# arguments for using functions without changing variables
ARG=$1 # user argument
FARG="-f" # starting firefox
UARG="-u" # unmounting manually
PARG="-p" # copie everything into ./preset from umounted dir

# check mounting status
if [[ $ARG && $ARG == $UARG ]]; then
    if mountpoint -q "$MOUNTDIR"; then
        unmountDir 5
        if ! mountpoint -q "$MOUNTDIR"; then
            echo "Successfully unmounted & encrypted"
        fi
    else
        echo "Already unmounted"
        exit 0
    fi

# save current environment
if [[ $ARG && $ARG == $PARG ]]; then
    cp -ra "$MOUNTDIR/*" "$WORKINGDIR/preset"
fi

elif ! mountpoint -q "$MOUNTDIR"; then
    mountDir # mount private directory
    echo "Successfully mounted" && notification 2
fi    

source "$WORKINGDIR/private.sh" # private directory environment reference changes & firefox
if [[ $USE_FIREFOX == "true" || $ARG && $ARG == "$FARG" ]]; then
    firefoxStart # starting firefox as background process and log output (look into private.sh)
fi

# automatic timeout based unmount
if [[ "$TIMEOUT" == "true" ]]; then
    unmountDir $TLIMIT
fi
