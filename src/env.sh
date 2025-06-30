#!/bin/bash

# override with origin home directory
originEnv() {
    ORIGIN_HOME="$HOME" # comment this out if it makes problems
    ORIGIN_XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
    ORIGIN_XDG_DATA_HOME="$XDG_DATA_HOME"
    ORIGIN_XDG_CACHE_HOME="$XDG_CACHE_HOME"
}

returnToOriginEnv() {
    export HOME="$ORIGIN_HOME" # comment this out if it makes problems
    export XDG_CONFIG_HOME="$ORIGIN_XDG_CONFIG_HOME"
    export XDG_DATA_HOME="$XDG_DATA_HOME"
    export XDG_CACHE_HOME="$ORIGIN_XDG_CACHE_HOME"
}

# references to ecryptfs resources
MOUNTFILE="$HOME/.ecryptfs/Private.mnt"
KEYFILE="$HOME/.ecryptfs/wrapped-passphrase"

# log files
APPLOG="$WORKINGDIR/app.log"

# options
SOUND="false" # sox notification sound
TIMEOUT="false" # automaticly umount after TLIMIT if no inteference
TLIMIT=60
USE_FIREFOX="false" # automaticly starting firefox with mounting the encrypted file system