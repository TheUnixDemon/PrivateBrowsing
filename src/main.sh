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
            if ! mountpoint -q "$MOUNTDIR"; then
                echo "Already unmounted"
                returnToOriginEnv
                exit 0
            else
                if returnToOriginEnv && ecryptfs-umount-private; then # unmount failed
                    echo "Successfully unmounted & encrypted" && notification 2
                    returnToOriginEnv
                    exit 0
                else
                    continue
                fi
            fi
        fi
    done
}

# environment variables & setup
export WORKINGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # location of bash script
source "$WORKINGDIR/env.sh" # basic environment variables (file locations)
source "$WORKINGDIR/setup.sh" # locate mounting directory and setup checked

# arguments for using functions without changing variables
ARG=$1 # user argument
FARG="-f" # starting firefox
UARG="-u" # unmounting manually
PARG="-p" # copie everything into ./preset from umounted dir

# unmount manually
if [[ $ARG && $ARG == $UARG ]]; then
    unmountDir 5
fi

# save current environment
if mountpoint -q "$MOUNTDIR" && [[ $ARG && $ARG == $PARG ]]; then
    cp -ra "$MOUNTDIR/." "$WORKINGDIR/preset"
fi

# mount directory
if ! mountpoint -q "$MOUNTDIR"; then
    mountDir # mounting
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

# starting new bash; loading config files
if [[ "$SHLVL" -eq 2 ]] && mountpoint -q "$MOUNTDIR"; then
    bash
    unmountDir 5 && exit 0
fi