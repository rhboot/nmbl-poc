#!/bin/bash

kern=$(grubby --default-kernel | cut -d'/' -f3 | cut -d'-' -f2-5)
entry=$(efibootmgr | grep BootCurrent | cut -d':' -f2)
entry=$(printf 'Boot%s' $entry)
ebe=$(efibootmgr | grep $entry | cut -f1)
echo "[$(date '+%H:%M:%S  %d-%m-%Y')] default kernel: $kern" >> /var/log/entry_booted.txt
echo "[$(date '+%H:%M:%S  %d-%m-%Y')] booted entry $ebe : $(uname -r)" >> /var/log/entry_booted.txt
