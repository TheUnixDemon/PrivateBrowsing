#!/bin/bash

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