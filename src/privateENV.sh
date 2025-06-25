#!/bin/bash

# checks folder structure and resources; fixes it with preset
checkEnvironment() {
    local ENV=$1
    local PRESET=$2
    if [ ! -d "$ENV" ]; then
        cp -ra "$PRESET" "$ENV" && echo "*$PRESET* copied to *$ENV*"
    fi
}

# application environment variables
export BROWSER_DIR="$PRIVATE_MOUNT/browser"
export FIREFOX_PROFILE="$BROWSER_DIR/firefox"
export FIREFOX_ERRLOG="$BROWSER_DIR/firefox_log.err"

# sets sandbox environment
export ENV="$PRIVATE_MOUNT/env"
export XDG_CONFIG_HOME="$ENV/.config"
export XDG_DATA_HOME="$ENV/.local/share"
export XDG_CACHE_HOME="$ENV/.cache"

# checks environment structure
PRESET="$SCRIPT_DIR/preset"
PRESET_BROWSER="$PRESET/browser"
checkEnvironment "$ENV" "$PRESET/env"
checkEnvironment "$BROWSER_DIR" "$PRESET_BROWSER"
checkEnvironment "$FIREFOX_PROFILE" "$PRESET_BROWSER/firefox"

# private mode settings
export SOUND=1 # for notifications beyond the shell using sox
export START_WITH=1 # automaticly stars firefox
export ENCRYPT_AFTER=1 # encrypts afterwards if firefox is fully closed
export ENCRYPT_IN_TIME=90 # time after *ENCRYPT_AFTER* was triggered; so you can resume the session if closed acedently
