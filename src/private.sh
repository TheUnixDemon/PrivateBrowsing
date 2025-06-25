#!/bin/bash

# setting up environmental variables
export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PRIVATE_MOUNT="$HOME/.private"

# notifications
notification() {
    local message=$1 && echo "$message"
    local numb=$2
    if [ $SOUND -eq 1 ]; then
        (
            for ((i=0; i<$numb; i++)); do
                play -n synth 0.3 sin 880 fade q 0.05 0.3 0.1 vol 0.2 > /dev/null 2>&1
                sleep 0.1
            done
        ) & disown
    fi
}

# acts like the flags are set
run() {
    if [ "$START_WITH" -eq 1 ]; then
        firefox --no-remote --profile "$FIREFOX_PROFILE" > /dev/null 2> $FIREFOX_ERRLOG & # starts usually hardend firefox
        sleep 5 # gives enough time to launch
        if [ "$ENCRYPT_AFTER" -eq 1 ]; then # unmount/encrypt after last instance of firefox is closed
            (
                while true; do
                    while pgrep -f "firefox.*$FIREFOX_PROFILE" > /dev/null || lsof +D "$PRIVATE_MOUNT" > /dev/null 2>&1; do # true until every instance of hardened firefox profile is no more
                        sleep $ENCRYPT_IN_TIME
                    done
                    if ecryptfs-umount-private; then
                        notification "successfully unmounted" 2
                        sleep 5
                        exit
                    fi
                    lsof +D "$PRIVATE_MOUNT" && notification "Some processes prevent unmounting" 1
                    sleep $ENCRYPT_IN_TIME # problems with exiting; proper output 
                    
                    
                done
            ) & disown
        fi
    fi
}

echo "$(tput setaf 1)---$(tput sgr0) You are going to start the private browsing mode $(tput setaf 1)---$(tput sgr0)"
echo ""
read -p "Are you sure about that? (y/n): " answer

if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
    if ecryptfs-mount-private && mountpoint -q "$PRIVATE_MOUNT"; then
        source $SCRIPT_DIR/privateENV.sh # loading more environment resources
        notification "successfully mounted" 2
        run
    fi
else
    echo "Process aborted"
fi
