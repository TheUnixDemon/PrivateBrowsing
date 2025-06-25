#!/bin/bash

# references to ecryptfs resources
MOUNTFILE="$HOME/.ecryptfs/Private.mnt"
KEYFILE="$HOME/.ecryptfs/wrapped-passphrase"

# log files
APPLOG="$WORKINGDIR/app.log"

# options
SOUND=0 # sox notification sound
TIMEOUT=0 # automaticly umount after TLIMIT if no inteference
TLIMIT=60
USE_FIREFOX=0 # automaticly starting firefox with mounting the encrypted file system