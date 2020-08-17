#!/bin/bash

## Refrech the library from cmus
## bind the update script to the cmus u key
## :bind -f common u shell ~/.config/cmus/update-library.sh

cmus-remote -C clear
cmus-remote -C "add /mnt/Musiques"
cmus-remote -C "update-cache -f"
