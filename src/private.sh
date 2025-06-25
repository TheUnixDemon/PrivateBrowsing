#!/bin/bash

# creates firefox profile and starts firefox with it
firefoxProfile() {
    local PROFILEPATH=$1
    local PROFILEPATHPRESET="$PRESET/browser/firefox"
    FIREFOXLOG="$MOUNTDIR/browser/firefox.log" # for creating new ones if new profile is created
    if [[ ! -d "$PROFILEPATH" ]]; then
        echo "Creating new Firefox profile ..."
        if [[ -d $PROFILEPATHPRESET ]] && cp -ra "$PROFILEPATHPRESET" "$PROFILEPATH"; then
            echo "Successfully tranfered from *preset*"
            break
        if firefox --CreateProfile "privateEncrypt '$PROFILEPATH'"; then
            echo "Successfully created"
            rm -f "$FIREFOXLOG"
        fi
    fi
    createLog "$FIREFOXLOG" # creates new log if not exiting
}

# will be called outside of *private.sh* -> *main.sh*
firefoxStart() {
    firefox --no-remote --profile "$FIREFOXLOG" > /dev/null 2> $FIREFOXLOG &
}

# adds/correcs directory structure if needed
validateEnvironment() {
    local RELATIVEPATH=$1
    if [[ ! -d "$MOUNTDIR/$RELATIVEPATH" ]]; then
        cp -ra "$PRESET/$RELATIVEPATH" "$MOUNTDIR/$RELATIVEPATH" && echo "*$PRESET/$RELATIVEPATH* copied to *$MOUNTDIR/$RELATIVEPATH*"
    fi
}

# check file/folder structure under private dir
PRESET="$WORKINGDIR/preset"
validateEnvironment "browser"
validateEnvironment "env"

# environment var references changed into private directories
export HOME="$MOUNTDIR/env"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# firefox profile and log creation as preperation for starting it
firefoxProfile()