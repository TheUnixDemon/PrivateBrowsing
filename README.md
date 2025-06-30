# Encrypted Directory

Using *ecryptfs-utils* this *Bash* script makes a setup for an encrypted environment inside of the created ecryptfs directory. It' works as it is under Arch Linux based systems.

## How to Use

Start the `src/main.sh` in a sub shell. It is using *Pacman* to install the dependencies. Also this script starts another Bash sub shell where the environment variables are loaded. If you're exiting the created sub shell the script will unmount the encrypted directory.

### Dependencies

The packages can be found within the `./src/setup.sh`.

* sox
* ecryptfs
* firefox

### Arguments

* `-u` - unmount directory
* `-p` - copie everything into `./preset`
* `-f` - start a Firefox instance

### Start Script        » Shell Level 1 - 2

You start the script in a sub shell when you are in Shell level **1**. So it will load up it's variables outside of your first Shell.

```bash
#!/bin/bash

./src/main.sh"
```

### Private Directory   » Shell Level 3

If you are within the private environment you are within the Shell level **3**. So you should use the script only with using **source** to load the script within the same.
(`$WORKINGDIR` - script location)

```bash
#!/bin/bash

SCRIPT=$(cd "$WORKINGDIR" && source "main.sh") # for example
```