# Browsing Private

Using Firefox (hardened by myself) and *ecryptfs-utils*. The sensitive data from Firefox will be saved within the private directory that is encrypted through *ecryptfs-utils*. Also you can start any applications within through the same terminal session to use the same environment location.

For now it's out of the box only released for **Arch** based systems. But you can modify the `./src/setup.sh` to get it working with Debian or other Linux based systems that 

## Setup

Normally you could just start the `./src/main.sh` to setup and start the script. But possibly you could also install the dependencies manually to get it working under other operating systems considering it's possible to execute bash commands. Under Arch it should install automaticly.

### Dependencies

The packages can be found within the `./src/setup.sh` and will be installed with the package manager *Pacman*.

* sox
* ecryptfs
* firefox

### Environment Variables

You should also look into the file `./src/private.sh` because of the environment variables that are set within. Because they relocate your configurations, caches and the hole reference to your home directory. 

To use it please execute the `./src/main.sh`.

```bash
#!/bin/bash
./src/main.sh
```