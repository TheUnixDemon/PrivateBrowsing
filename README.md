# Browsing Private
Using Firefox (hardened by myself) and *ecryptfs-utils*. The sensitive data from Firefox will be saved within the private directory that is encrypted through *ecryptfs-utils*.

## Setup Arch Linux
```bash
cd src && ./main.sh # installing dependencies automaticly (normally)
```

Changes that could benefit are to find into the `src/env.sh` and `src/private.sh`. There are file references and options for this applications as an handler for ecryptfs.