#!/bin/bash

# creates firefox profile and starts firefox with it
firefoxProfile() { 
    if [[ ! -d "$PROFILEPATH" ]]; then
        echo "*$PROFILEPATH* not found"
        echo "Creating new Firefox profile ..."
        if [[ -d $PROFILEPATHPRESET ]] && cp -ra "$PROFILEPATHPRESET" "$PROFILEPATH"; then # if profile preset dir exists -> cp to encrypted mounted dir
            echo "Successfully profile tranfered from preset *$PROFILEPATHPRESET* to encryption directory *$PROFILEPATH*"
        elif firefox --no-remote --CreateProfile "$PROFILENAME $PROFILEPATH"; then #|| firefox --ProfileManager; then
            if [[ ! -d "$PROFILEPATH" ]]; then
                echo "The command *firefox --CreateProfile ...* was unsuccessul"
                echo "Please create at *$PROFILEPATH* manually a profile ..."
                firefox --no-remote --ProfileManager
            else
                echo "Successfully created a new profile"

            fi
        fi
    fi
}

# will be called outside of *private.sh* -> *main.sh*
firefoxStart() {
    if firefoxProfile; then
        if [[ -f "$FIREFOXLOG" ]]; then
            rm -f "$FIREFOXLOG" && touch "$FIREFOXLOG"
        fi
        firefox --no-remote --profile "$PROFILEPATH" > /dev/null 2> $FIREFOXLOG &
        if [[ $? -ne 0 ]]; then
            echo "starting Firefox with profile located at *$PROFILEPATH* was unsuccessful"
        fi
    fi
}

# adds/correcs directory structure if needed
validateEnvironment() {
    local RELATIVEPATH=$1
    if [[ ! -d "$MOUNTDIR/$RELATIVEPATH" ]]; then
        if [[ -d "$PRESET/$RELATIVEPATH" ]]; then
            cp -ra "$PRESET/$RELATIVEPATH/." "$MOUNTDIR/$RELATIVEPATH" && echo "*$PRESET/$RELATIVEPATH* copied to *$MOUNTDIR/$RELATIVEPATH*" # including hidden files (/.) 
        else # create directory structure without preset
            mkdir -p "$MOUNTDIR/$RELATIVEPATH" && echo "Preset can't be found; Plain directory *$MOUNTDIR/$RELATIVEPATH* was created successfully"
        fi
    fi
}

# check file/folder structure under private dir
PRESET="$WORKINGDIR/preset"
# folder for profile and log data referenced to firefox
validateEnvironment "browser"
# environment for references, configs and locals
validateEnvironment "env"
validateEnvironment "env/.config"
validateEnvironment "env/.local/share"
validateEnvironment "env/.cache"

# environment var references changed into private directories
originEnv # save origin environment locations in variables

ENV="$MOUNTDIR/env"
export HOME=$ENV # comment this out if it makes problems
export XDG_CONFIG_HOME="$ENV/.config"
export XDG_DATA_HOME="$ENV/.local/share"
export XDG_CACHE_HOME="$ENV/.cache"

# firefox profile and log variables
FIREFOXLOG="$MOUNTDIR/browser/firefox.log"
PROFILENAME="privateEncrypt"
PROFILEPATH="$MOUNTDIR/browser/firefox"
PROFILEPATHPRESET="$PRESET/browser/firefox"
