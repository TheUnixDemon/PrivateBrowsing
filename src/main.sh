#!/bin/bash

# sound notificatibased on *sox*
notification() {
    local rounds=${2:-1}
    if $SOUND; then
        (
            for  (( i = 0; i < rounds; i++ )); do
                play -n synth 0.3 sin 880 fade q 0.05 0.3 0.1 vol 0.2 > /dev/null 2>&1
                sleep 0.1
            done
        ) & disown
    fi
}

# mount private dir (interactive)
mountDir() {
    echo "$(tput setaf 1)<--<$(tput sgr0) Mounting encrypted directory at *$MOUNTDIR* $(tput setaf 1)>-->$(tput sgr0)"
    while true; do
        read -p "Confirm? (y/N)" answer
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


# environment variables & setup
WORKINGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # location of bash script
source "$WORKINGDIR/env.sh" # basic environment variables (file locations)
source "$WORKINGDIR/setup.sh" # locate mounting directory and setup checked

# check mounting status
if ! mountpoint -q "$MOUNTDIR"; then
    mountDir # mount private directory
    notification 2
    
# private directory environment reference changes & firefox
source "$WORKINGDIR/private.sh"
if $USE_FIREFOX; then
    firefoxStart # starting firefox as background process and log output (look into private.sh)
fi

# automatic timeout based unmound
while true; do
    sleep $TLIMIT
    # checks if can be is unmounted (encrypted); only if no process is using the dir possible (lsof) 
    if ! lsof +D "$MOUNTDIR" >> $APPLOG 2>&1; then
        if ! ecryptfs-umount-private; then # unmount failed
            continue
        fi
        notification 2
        exit 0
    fi
done